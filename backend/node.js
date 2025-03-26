import * as dotenv from "dotenv";
import OpenAI from "openai";

dotenv.config();

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY, // Use environment variable
  baseURL: "https://api.sree.shop/v1", // Set your custom base URL
});

async function runOpenAI() {
  try {
    const response = await openai.chat.completions.create({
      model: "gpt-4o",
      messages: [
        {
          role: "user",
          content: "how should i make you function to send you image and i should get food items write a function to api call for gpt-4o",
        },
      ],
    });

    console.log(response.choices[0].message.content);
  } catch (error) {
    console.error("Error:", error);
  }
}

runOpenAI();
