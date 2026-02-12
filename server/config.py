from dotenv import load_dotenv
from pydantic_settings import BaseSettings
load_dotenv()  # Load environment variables from a .env file

class Settings(BaseSettings):
     TAVILY_API_KEY:str= ""  # Define a setting for the TAVILY API key
     GEMINI_API_KEY:str= ""  # Define a setting for the GEMINI API key