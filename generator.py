
from fastapi.responses import JSONResponse
import os
import base64
import PyPDF2
import nltk
from nltk.tokenize import sent_tokenize, word_tokenize
from fastapi import FastAPI, HTTPException, Body
from typing import List, Dict
import os
from fastapi.responses import JSONResponse
from nltk import ne_chunk
import random
from fastapi import FastAPI, WebSocket, APIRouter, HTTPException, Request, Depends

from typing import Dict, List

nltk.download('punkt')
nltk.download('stopwords')
nltk.download('maxent_ne_chunker')
nltk.download('words')
nltk.download('averaged_perceptron_tagger')

question_patterns = [
    "What is {entity} and why does it matter?",
    "Tell me about {entity} and its relation.",
    "How does {entity} impact and what are the consequences?",
    "Explore the role of {entity} and draw lessons from their experiences.",
    "Discuss the significance of {entity}  and its relevance today.",
    "Evaluate the effectiveness of {entity} in achieving and suggest improvements if necessary.",
    "What is {entity} and why is it important?",
    "Can you provide an overview of {entity}?",
    "How would you define {entity}?",
    "Tell me about the significance of {entity}.",
    "Explain the role of {entity}.",
    "Discuss the impact of {entity} on the subject matter.",
    "Why is {entity} relevant in this context?",
    "Share your insights on {entity}.",
    "Elaborate on the importance of {entity}.",
    "In your own words, describe {entity}.",
    "What can you tell me about {entity}?",
    "Why should we care about {entity}?",
    "Examine the significance of {entity}.",
    "Provide your thoughts on {entity}.",
    "What do you know about {entity}?",
    "Explore the relevance of {entity} in this context.",
    "How does {entity} influence our understanding?",
    "Elaborate on the role of {entity} in this field.",
    "Why is {entity} noteworthy?",
    "What insights can you share about {entity}?",
]

# Function to extract text from a PDF
def extract_text_from_pdf(pdf_path):
    text = ''
    with open(pdf_path, 'rb') as pdf_file:
        pdf_reader = PyPDF2.PdfReader(pdf_file)
        for page_num in range(len(pdf_reader.pages)):
            page = pdf_reader.pages[page_num]
            text += page.extract_text()
    return text


# Function to extract entities from text
def extract_entities(text):
    sentences = sent_tokenize(text)
    entities = []

    for sentence in sentences:
        words = word_tokenize(sentence)
        tagged = nltk.pos_tag(words)
        named_entities = ne_chunk(tagged)

        for subtree in named_entities:
            if isinstance(subtree, nltk.Tree):
                entity = " ".join([word for word, tag in subtree.leaves()])
                entities.append((entity, subtree.label()))

    return entities

def generate_questions(entities):
    # questions = []
    # for entity, entity_type in entities:
    #     if entity_type == 'GPE' or entity_type == 'ORGANIZATION' or entity_type == 'PERSON':
    #         # Generate different types of questions based on your preference
    #         for pattern in question_patterns:
    #             question = pattern.format(entity=entity)
    #             questions.append(question)
    #
    # return questions
    questions = []
    for entity, entity_type in entities:
        if entity_type == 'GPE' or entity_type == 'ORGANIZATION' or entity_type == 'PERSON':
            # Randomly select a question pattern
            pattern = random.choice(question_patterns)
            question = pattern.format(entity=entity)
            questions.append(question)

    return questions

router = APIRouter()


# @router.post("/upload")
# async def upload_pdf(file: UploadFile):
#     # Define the folder where PDF files will be stored
#     pdf_folder = "pdf"
#
#     # Ensure the folder exists or create it if not
#     Path(pdf_folder).mkdir(parents=True, exist_ok=True)
#     if file.content_type != "application/pdf":
#         return JSONResponse(content={"error": "Only PDF files are allowed."}, status_code=400)
#
#     file_path = os.path.join(pdf_folder, file.filename)
#
#     with open(file_path, "wb") as pdf_file:
#         pdf_file.write(file.file.read())
#
#     return JSONResponse(content={"message": "PDF file uploaded successfully", "file_path": file_path})


def generator(path):
    pdf_path = path
    # Extract text from the PDF
    book_text = extract_text_from_pdf(pdf_path)

    # Extract entities from the book text
    entities = extract_entities(book_text)

    # Generate definition-type questions from the entities
    all_question = generate_questions(entities)

    # Create a diagram-related question if "diagram" is found
    # diagram_question = create_diagram_question('book.pdf', book_text, entities)

    # Print the questions
    random.shuffle(all_question)
    list = []
    for i, question in enumerate(all_question, start=1):
        if len(question) > 45 and len(question.split()) == len(set(question.split())):
            #print(f"Question {i}: {question}")
            list.append(question)
    # Create a new list to store unique strings
    unique_q = []

    # Iterate through the original list and add unique strings to the new list
    for question in list:
        if question not in unique_q:
            unique_q.append(question)
    return unique_q
    # if diagram_question:
    #     print(f"Diagram Question: {diagram_question}")




@router.post("/upload")
async def upload_pdf(message: Request):
    try:
        data = await message.json()
        pdf_folder = "pdf"

        os.makedirs(pdf_folder, exist_ok=True)

        pdf_data = bytes(data["data"])
        file_path = os.path.join(pdf_folder, data["name"])
        #
        with open(file_path, "wb") as pdf_file:
            pdf_file.write(pdf_data)
        data = generator(file_path)
        return JSONResponse(content={"message": "Uploadded Done!", "file_path": file_path, "questions" : data})
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/history")
async def get_pdf_files(history: bool = False):
    pdf_folder_path = "project/question_generator/assets/papers"
    files = []

    if history:
        # Traverse the pdf folder and extract all file names
        for root, _, filenames in os.walk(pdf_folder_path):
            for filename in filenames:
                files.append(os.path.join(root, filename))
    else:
        # Only list files in the top-level pdf folder
        files = [f for f in os.listdir(pdf_folder_path) if os.path.isfile(os.path.join(pdf_folder_path, f))]

    # Convert the list of file names to a JSON response
    response_content = {"files": files}
    return JSONResponse(content=response_content)

# @router.post("/generate")
# async def generator(message: Request):
#     data = await message.json()
#     pdf_path = data["path"]
#     # Extract text from the PDF
#     book_text = extract_text_from_pdf(pdf_path)
#
#     # Extract entities from the book text
#     entities = extract_entities(book_text)
#
#     # Generate definition-type questions from the entities
#     all_question = generate_questions(entities)
#
#     # Create a diagram-related question if "diagram" is found
#     # diagram_question = create_diagram_question('book.pdf', book_text, entities)
#
#     # Print the questions
#     random.shuffle(all_question)
#     list = []
#     for i, question in enumerate(all_question, start=1):
#         if len(question) > 50 and len(question.split()) == len(set(question.split())):
#             #print(f"Question {i}: {question}")
#             list.append(question)
#
#     return {"questions": list}
#     # if diagram_question:
#     #     print(f"Diagram Question: {diagram_question}")
#
