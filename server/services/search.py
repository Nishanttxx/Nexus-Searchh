from config import Settings
from tavily import TavilyClient
import trafilatura
settings=Settings()
tavily_client = TavilyClient(api_key=settings.TAVILY_API_KEY)


class SearchService:
    def web_search(self, query: str):
        # Implementation of web search logic,self is used  To access object data & methods
        try:
          results=[]
          response = tavily_client.search(query,max_results=10)# Perform a web search using the Tavily client with the provided query and a maximum of 10 results
          search_results=response.get("results", [])
  
          for result in search_results: 
              downloaded=trafilatura.fetch_url(result.get("url"))# Fetch the content of each search result URL using Trafilatura for further processing or analysis
              content=trafilatura.extract(downloaded,include_comments=False)# Extract the main content from the downloaded web page, excluding comments
  
              results.append({
                  "title": result.get("title", ""),
                  "url": result.get("url", ""),
                  "content": content or "",
  
  
              })# Print the extracted content for each search result
          return results
        except Exception as e:
            print(e)