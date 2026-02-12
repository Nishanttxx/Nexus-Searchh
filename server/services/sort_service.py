from typing import List
from sentence_transformers import SentenceTransformer
import numpy as np


class SortService:
    def __init__(self):
        self.embedding_model = SentenceTransformer("all-miniLM-L6-v2")  # Initialize the SentenceTransformer model for generating embeddings

    def sort_source(self, query: str, sources: list[dict]):  # this method takes a query string and a list of source dictionaries as input
        try:
            if not sources:
                return []
            relevant_docs = []  # Initialize an empty list to store relevant documents
            query_embedding = self.embedding_model.encode(query)  # Generate the embedding for the input query using the embedding model
            for res in sources:
                content = res.get("content") or ""
                res_embedding = self.embedding_model.encode(content)  # Generate the embedding for the content of each source in the list
                similarity =float(np.dot(query_embedding, res_embedding) / (np.linalg.norm(query_embedding) * np.linalg.norm(res_embedding)))  # Calculate the cosine similarity between the query embedding and the source content embedding
                res["relevance_score"] = similarity  # Store the similarity score in the source dictionary
                if similarity > 0.5:  # If the similarity score is greater than 0.5, consider the source as relevant,used for filtering the sources based on relevance
                    relevant_docs.append(res)  # Add the relevant source to the list of relevant documents
            if relevant_docs:
                return sorted(relevant_docs, key=lambda x: x["relevance_score"], reverse=True)  # Return the list of relevant documents sorted by their relevance score in descending order
            return sorted(sources, key=lambda x: x.get("relevance_score", 0), reverse=True)
        except Exception as e:
            print(e)
