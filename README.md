# the-story-within-ecommerce
An innovative e-commerce bookstore built on PrestaShop, featuring a RAG-based AI shopping assistant (Llama 3 via Groq API), real-time product customization, and gamified shopping experiences. (Bachelor's Thesis Project)
# 🦉 The Story Within - Smart E-Commerce Platform

**The Story Within** is an innovative e-commerce bookstore developed as a Bachelor's Thesis project. Built on top of the PrestaShop architecture, it transcends traditional online retail by integrating Generative AI, gamification, and real-time graphic customization to deliver a highly interactive user experience.

## ✨ Key Features

### 1. Fable, The Magic Owl (AI Shopping Assistant)
A conversational AI assistant powered by **Llama 3** (via **Groq API**) designed to act as a digital bookseller.
* **RAG Architecture (Retrieval-Augmented Generation):** The AI is strictly anchored to the store's MySQL database. It dynamically reads the inventory and recommends *only* books that are currently in stock.
* **Smart Token Optimization:** A custom PHP middleware parses user prompts to inject full book descriptions only when relevant keywords are detected, saving API tokens.
* **Interactive UI:** AI responses are automatically parsed via Regex to generate clickable HTML buttons directly in the chat window.

### 2. Live Preview Product Customizer
A dynamic frontend module allowing users to create personalized book dedications.
* **Real-Time DOM Manipulation:** Built with JavaScript/jQuery to instantly render text, custom fonts (including cursive), and HEX colors on the product mockup.
* **FileReader API Integration:** Users can upload custom background images from their PC, which are rendered instantly in the browser without server-side latency.

### 3. Dynamic Pricing Algorithm
A custom backend PHP module that calculates customization fees dynamically in the cart.
* Implements a **Volume Discount Strategy** (e.g., standard price for the first dedication, discounted price for subsequent ones).
* Uses PrestaShop's native `SpecificPrice` class and virtual carrier products to apply fees without altering the main product catalog.

### 4. "Blind Date with a Book" (Gamification)
An interactive module where users configure their reading preferences (Genre, Tropes, Cozy Drink) instead of picking a specific title.
* Frontend validation limits user selections (e.g., max 3 tropes).
* Data is stored cleanly in a custom MySQL table and bypassed by the dynamic pricing algorithm using a specific `blind_date` flag.
* Preferences are displayed cleanly in the Back-Office, providing the admin with a quick psychological/literary profile of the buyer to fulfill the order.

## 🛠️ Tech Stack

* **Backend:** PHP, MySQL (PrestaShop Core & Custom Modules)
* **Frontend:** JavaScript, jQuery, HTML5, CSS3, Smarty (Templates)
* **AI & API Integration:** Groq API, Meta Llama 3 (llama-3.1-8b-instant), cURL, JSON
* **Architecture:** MVC, Hooks, RAG (Retrieval-Augmented Generation)

## 🎓 About
This project was developed by **Denisa Coman** as a Bachelor's Thesis for the Faculty of Economic Sciences and Business Administration, Transilvania University of Brașov (2026). It serves as a proof-of-concept for how modern web technologies and Artificial Intelligence can re-humanize the digital retail experience.

## 🚀 Installation & Setup

### Prerequisites
* **PrestaShop** (Version 1.7.8 or higher)
* **PHP** (7.4 or higher)
* A valid [Groq API Key](https://console.groq.com/) for the AI assistant.

### Step-by-Step Guide
1. **Module Installation:** Download this repository and copy the `productcustomizer` folder into the `/modules/` directory of your PrestaShop installation.
2. **Activation:** Log into your PrestaShop Back-Office. Navigate to *Modules -> Module Manager*, search for **ProductCustomizer**, and click **Install**. The module will automatically create the required custom database tables (`ps_product_customizer_dedication`) and the virtual fee product.
3. **Configure Pricing:** Click on "Configure" on the module to set your *Standard Price* and *Discounted Price* for the dynamic pricing algorithm.
4. **AI Setup:** Place the `fable-api.php` script in your desired directory. Open the file and replace `$apiKey = 'YOUR_GROQ_API_KEY_HERE';` with your actual Groq API key.

## 💡 How It Works (Usage)

### For Customers (Front-Office)
* **Live Customization:** Navigate to any book product page. Toggle the customization section to write a dedication, choose fonts (e.g., cursive), and pick a background. The **Live Preview** will render your choices instantly.
* **AI Assistant:** Click the floating Fable Owl icon. Ask for book recommendations based on tropes or moods. Fable will fetch real-time data from the store's inventory and provide clickable links to the books.
* **Blind Date:** Add a "Blind Date with a Book" to the cart and configure your reading preferences (Genre, Tropes, Drink). The cart will cleanly display your choices without applying the standard dedication fee.

### For Store Admins (Back-Office)
* When an order is placed, go to the **Orders** tab in the PrestaShop admin panel.
* A custom panel will automatically display the exact text, font, color, and background chosen by the user for custom dedications.
* For "Blind Date" orders, the admin will see a clean list of the user's literary preferences, allowing for quick and accurate order fulfillment.
