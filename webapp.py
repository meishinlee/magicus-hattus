# import numpy as np
import gradio as gr

def uploadedImage(image):
    return "image"

def uploadedVideo(video):
    return "video"


with gr.Blocks() as demo:
    ##### Intro #####
    gr.Markdown("<h1><center>Turn yourself into a magician using this tool!</center></h1>")

demo.launch(share=True)
