# main.py
import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from generator import router as generator
from template import router as temp
# CORS configuration

os.makedirs("images", exist_ok=True)
os.makedirs("files", exist_ok=True)

app = FastAPI()

origins = ["*"]
laptop_ip = "52.0.41.103"
# laptop_ip = "127.0.0.1"

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins  + [f"http://{laptop_ip}"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(generator, prefix="/api", tags=["generator"])
app.include_router(temp, prefix="/api", tags=["template"])


app.mount("/pdf", StaticFiles(directory="pdf"), name="pdf")
app.mount("/papers", StaticFiles(directory="papers"), name="papers")




# Run the server
if __name__ == "__main__":
    import uvicorn
    # uvicorn.run(app, host="0.0.0.0", port=8000)
    uvicorn.run(app, host="127.0.0.1", port=8000)
