import gradio as gr
import matlab.engine
import numpy as np
import PIL

eng = matlab.engine.start_matlab()

def uploadedImage(image):
    image_mat = matlab.uint8(list(image.transpose(PIL.Image.Transpose.TRANSPOSE).getdata()))
    image_mat.reshape((image.size[1], image.size[0], 3))
    image_with_hat = eng.place_hat(image_mat)
    image_out = np.array(image_with_hat)
    return image_out

def uploadedVideo(video):
    return "video"


with gr.Blocks() as demo:
    ##### Intro #####
    gr.Markdown("<h1><center>Turn yourself into a magician using this tool!</center></h1>")

    ##### Upload Image/Video #####
    webcam_input = gr.Image(source="webcam", type='pil')
    with gr.Tabs():
        with gr.TabItem("Upload Image (Recommended)"):
            image_input = gr.Image(type='pil')
            image_output = gr.Image()
            image_button = gr.Button("Submit")
            image_button.style(rounded=True, border=False, full_width=True)
          
        with gr.TabItem("Upload Video"):
            video_input = gr.Video()
            video_output = gr.Video()
            video_button = gr.Button("Submit")
            video_button.style(rounded=True, border=False, full_width=True)

        with gr.TabItem("Take a Picture"):
            #webcam_input = gr.Image(source="webcam", type='pil') 
            webcam_output = gr.Image()
            webcam_button = gr.Button("Snap a photo!")
            webcam_button.style(rounded=True, border=False, full_width=True)

    image_button.click(uploadedImage, inputs=image_input, outputs=image_output)
    video_button.click(uploadedVideo, inputs=video_input, outputs=video_output)
    webcam_button.click(uploadedImage, inputs=webcam_input, outputs=webcam_output)

demo.launch(share=True)
