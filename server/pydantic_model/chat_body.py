from pydantic import BaseModel


class ChatBody(BaseModel):#creating a data model named ChatBody and it is inheriting from BaseModel
    query:str# Define a Pydantic model with a single field 'query' of type string