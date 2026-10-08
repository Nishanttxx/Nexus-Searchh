import math
import sys
from unittest.mock import MagicMock, patch

import pytest

# Ensure numpy and sentence_transformers can be imported even if heavy ML libraries aren't installed in the environment
if "numpy" not in sys.modules:

    class FakeNumpy:
        @staticmethod
        def dot(a, b):
            return sum(x * y for x, y in zip(a, b))

        @staticmethod
        def isscalar(obj):
            return isinstance(obj, (int, float, bool, complex))

        class linalg:
            @staticmethod
            def norm(a):
                return math.sqrt(sum(x * x for x in a))

    sys.modules["numpy"] = FakeNumpy()

if "sentence_transformers" not in sys.modules:

    class FakeSTModule:
        class SentenceTransformer:
            def __init__(self, *args, **kwargs):
                pass

    sys.modules["sentence_transformers"] = FakeSTModule()

from server.services.sort_service import SortService


@pytest.fixture
def mock_sort_service():
    with patch("server.services.sort_service.SentenceTransformer") as mock_transformer:
        mock_model = MagicMock()
        mock_transformer.return_value = mock_model
        service = SortService()
        yield service, mock_model


def test_sort_source_empty_sources(mock_sort_service):
    service, _ = mock_sort_service
    result = service.sort_source("test query", [])
    assert result == []


def test_sort_source_relevant_docs_filtered_and_sorted(mock_sort_service):
    service, mock_model = mock_sort_service

    # Vectors yielding distinct cosine similarities:
    # Query: [1, 0]
    # Doc1 ("high"): [1, 0] -> similarity 1.0 (> 0.5)
    # Doc2 ("medium"): [0.8, 0.6] -> similarity 0.8 (> 0.5)
    # Doc3 ("low"): [0, 1] -> similarity 0.0 (<= 0.5)
    def fake_encode(text):
        if text == "query":
            return [1.0, 0.0]
        elif text == "high relevance":
            return [1.0, 0.0]
        elif text == "medium relevance":
            return [0.8, 0.6]
        elif text == "low relevance":
            return [0.0, 1.0]
        return [1.0, 0.0]

    mock_model.encode.side_effect = fake_encode

    sources = [
        {"id": 1, "content": "medium relevance"},
        {"id": 2, "content": "low relevance"},
        {"id": 3, "content": "high relevance"},
    ]

    sorted_sources = service.sort_source("query", sources)

    # Should only contain relevant docs (>0.5 threshold) sorted descending
    assert len(sorted_sources) == 2
    assert sorted_sources[0]["id"] == 3
    assert abs(sorted_sources[0]["relevance_score"] - 1.0) < 1e-5
    assert sorted_sources[1]["id"] == 1
    assert abs(sorted_sources[1]["relevance_score"] - 0.8) < 1e-5


def test_sort_source_fallback_when_no_docs_exceed_threshold(mock_sort_service):
    service, mock_model = mock_sort_service

    # Vectors with similarity <= 0.5
    # Query: [1, 0]
    # Doc1: [0.4, 0.916515138991168] -> similarity 0.4
    # Doc2: [0.2, 0.9797958971132712] -> similarity 0.2
    def fake_encode(text):
        if text == "query":
            return [1.0, 0.0]
        elif text == "doc1":
            return [0.4, 0.916515138991168]
        elif text == "doc2":
            return [0.2, 0.9797958971132712]
        return [1.0, 0.0]

    mock_model.encode.side_effect = fake_encode

    sources = [
        {"id": 2, "content": "doc2"},
        {"id": 1, "content": "doc1"},
    ]

    sorted_sources = service.sort_source("query", sources)

    # Fallback return all sources sorted by relevance_score descending
    assert len(sorted_sources) == 2
    assert sorted_sources[0]["id"] == 1
    assert abs(sorted_sources[0]["relevance_score"] - 0.4) < 1e-5
    assert sorted_sources[1]["id"] == 2
    assert abs(sorted_sources[1]["relevance_score"] - 0.2) < 1e-5


def test_sort_source_missing_or_none_content(mock_sort_service):
    service, mock_model = mock_sort_service

    mock_model.encode.return_value = [1.0, 0.0]

    sources = [
        {"id": 1},  # missing content key
        {"id": 2, "content": None},  # content is None
    ]

    sorted_sources = service.sort_source("query", sources)

    # Check encode was called for "" when content is missing or None
    encoded_args = [call.args[0] for call in mock_model.encode.call_args_list]
    assert "" in encoded_args
    assert len(sorted_sources) == 2


def test_sort_source_handles_exception(mock_sort_service):
    service, mock_model = mock_sort_service

    mock_model.encode.side_effect = Exception("Model encoding failed")

    sources = [{"id": 1, "content": "test"}]
    # Exception caught inside sort_source, method prints exception and returns None
    result = service.sort_source("query", sources)
    assert result is None
