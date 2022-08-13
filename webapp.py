import gradio as gr
import matlab.engine

eng = matlab.engine.start_matlab()

def uploadedImage(image):
    image_with_hat = eng.place_hat(image)
    return image_with_hat

def uploadedVideo(video):
    return "video"


with gr.Blocks() as demo:
    ##### Intro #####
    gr.Markdown("<h1><center>Turn yourself into a magician using this tool!</center></h1>")

    ##### Upload Image/Video #####
    with gr.Tabs():
        with gr.TabItem("Upload Image (Recommended)"):
            image_input = gr.Image()
            image_output = gr.Image()
            image_button = gr.Button("Submit")
            image_button.style(rounded=True, border=False, full_width=True)
          
        with gr.TabItem("Upload Video"):
            video_input = gr.Video()
            video_output = gr.Video()
            video_button = gr.Button("Submit")

    image_button.click(uploadedImage, inputs=image_input, outputs=image_output)
    video_button.click(uploadedVideo, inputs=video_input, outputs=video_output)

demo.launch(share=True)
