import asyncio
from fastapi import FastAPI, WebSocket
from pydantic_model.chat_body import ChatBody#used for integration with FastAPI
from services.llm_services import LLMService
from services.sort_service import SortService
from services.search import SearchService # Import FastAPI class

app = FastAPI()#it should be named as app

search_service = SearchService()# Create an instance of SearchService
sort_service=SortService()# Create an instance of SortService
llm_service=LLMService()# Create an instance of LLMService

@app.websocket("/ws/chat")
async def websocket_chat(websocket:WebSocket):
   await websocket.accept()

   try:
      await asyncio.sleep(0.1)
      data=await websocket.receive_json()
      query=data.get("query")
      search_results=search_service.web_search(query) or []# Perform a web search using the SearchService with the query from the request body
      sorted_results=sort_service.sort_source(query, search_results) or []# Sort the sources based on their relevance to the queryreturn body.query
      await asyncio.sleep(0.1)
      await websocket.send_json({
          "type":"search_result",
          "data":sorted_results
       })

      for chunk in llm_service.generate_response(query, sorted_results):# Generate a response using the LLMService with the query and sorted search results
        await asyncio.sleep(0.1)
        await websocket.send_json({"type":"content","data":chunk})
   except:
      print("unexcepted error occured")
   finally:
      await websocket.close()



#chat
@app.post("/chat")
def chat_endpoint(body:ChatBody):#tells python that the body must be in the format defined by ChatBody model
   search_results=search_service.web_search(body.query) or []# Perform a web search using the SearchService with the query from the request body
   sorted_results=sort_service.sort_source(body.query, search_results) or []# Sort the sources based on their relevance to the queryreturn body.query
   response=llm_service.generate_response(body.query, sorted_results)# Generate a response using the LLMService with the query and sorted search results
   return response
    
    
