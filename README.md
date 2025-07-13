# MULTIMODAL MULTILABEL MOVIE GENRE PREDICTION WITH EARLY FUSION: MODEL AND APP INTEGRATION

This repository showcases the architecture and methodology for a multi-modal deep learning system designed to predict a movie's genre from its poster (image) and overview (text). The system leverages a custom **Early Fusion** model to combine visual and textual features for more accurate predictions.

## 📌 Project Status & Deployment Note

This project was developed as a proof-of-concept using the **Google Cloud Platform (GCP) Free Tier**. Due to the transient nature of these resources and to manage costs, the service is **not currently live or publicly accessible**.

The primary purpose of this repository is to serve as a portfolio piece, demonstrating the system's architecture, the data processing pipeline, and the machine learning methodology employed.

## 🚀 Key Features

*   **Multi-modal Analysis:** Processes both visual (movie poster) and textual (movie overview) data to make a holistic prediction.
*   **AI-Powered Data Enrichment:** Utilizes Microsoft's **Florence-2** model to generate descriptive captions from movie posters, enriching the textual data for the model.
*   **Custom Deep Learning Model:** Implements a custom **Early Fusion** architecture to effectively combine image and text features at an early stage of the network.
*   **End-to-End System Design:** The architecture covers the entire process, from user input and data pre-processing to model inference and displaying the final output.

## ⚙️ System Architecture

The overall workflow of the system is illustrated in the diagram below.
Architecture](path/to/your/architecture_diagram.png)
> **Note:** Please update the `path/to/your/architecture_diagram.png` with the actual path to the diagram image in your repository (e.g., `docs/system_architecture.png`).

### Architectural Workflow

1.  **User Input:** The process begins with the user providing a movie poster (image) and a brief overview (text) through a user interface.
2.  **Poster Caption Generation:** The movie poster is sent to an external **Florence API Service**. The Florence-2 model analyzes the image and generates a descriptive `Poster Caption`. This step enriches the input data by extracting contextual information directly from the visual content.
3.  **Pre-processing:**
    *   **Image Pre-processing:** The original movie poster is resized, normalized, and transformed into the format required by the vision model.
    *   **Text Pre-processing:** The user-provided overview and the AI-generated poster caption are concatenated. This combined text is then cleaned, tokenized, and prepared for the language model.
4.  **Model & Prediction:**
    *   The pre-processed image and text tensors are fed into the **Custom Early Fusion Model**.
    *   The model integrates these multi-modal features to perform a final classification, predicting the movie's genre(s).
5.  **Output:** The predicted genre is sent back and displayed to the user in the output interface.
<img width="1920" height="1080" alt="Screenflow Diagram Flowchart Whiteboard in Pink Yellow Adjacent Color Blocks Style-3" src="https://github.com/user-attachments/assets/bba7b716-cb7b-4f33-be18-120b8fae89de" />

## 🛠️ Technology Stack

*   **Cloud Platform:** Google Cloud Platform (GCP)
*   **Backend:** Python
*   **API Service:** Flask / FastAPI
*   **Deep Learning Framework:** PyTorch
*   **Vision Model Component:** EfficientNet / ResNet (or similar)
*   **Language Model Component:** DistilBERT / RoBERTa (or similar)
*   **External AI Service:** Microsoft Florence-2 for image captioning


## 📄 License

This project is distributed under the MIT License. See the `LICENSE` file for more information.

## 🙏 Acknowledgments

*   The **Microsoft Florence-2** team for their powerful vision foundation model.
*   The open-source community for the libraries and tools that made this project possible.
*   The providers of the dataset(s) used for model training.

![Proje Teklİfİ Sunumu](https://github.com/user-attachments/assets/1b7b3963-ba25-48c1-8b08-967c251a5781)
