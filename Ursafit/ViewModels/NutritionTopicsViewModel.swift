//
//  NutritionTopicsViewModel.swift
//  Ursafit
//
//  Created by Corey Buckingham on 11/16/24.
//

import Foundation

class NutritionTopicsViewModel: ObservableObject {
    @Published var topics: [NutritionTopic] = [
        NutritionTopic(
            title: "Hydration 💧",
            details: """
                Water plays a fundamental role in maintaining bodily functions such as regulating temperature, aiding digestion, and transporting nutrients. Proper hydration ensures your energy levels, brain function, and overall health are optimized. Dehydration can lead to fatigue, headaches, and impaired focus.
            """,
            keyPoints: [
                "Vital for temperature regulation and joint lubrication.",
                "Essential for nutrient and oxygen transportation.",
                "Prevents fatigue and supports brain function."
            ],
            tips: [
                "Drink consistently throughout the day, not just when thirsty.",
                "Carry a reusable water bottle to remind yourself to hydrate.",
                "Add flavor to water with lemon, cucumber, or mint for variety."
            ]
        ),
        NutritionTopic(
            title: "Macronutrients 🍗",
            details: """
                Macronutrients—carbohydrates, proteins, and fats—provide the body with energy and support its essential functions. Carbohydrates fuel the brain and muscles, proteins help repair tissues, and fats are crucial for cell structure and long-term energy.
            """,
            keyPoints: [
                "Carbohydrates are the primary energy source.",
                "Proteins support muscle repair and immune health.",
                "Healthy fats are critical for hormone production and brain health."
            ],
            tips: [
                "Include complex carbs like whole grains and sweet potatoes for sustained energy.",
                "Opt for lean proteins such as fish, legumes, and poultry.",
                "Incorporate healthy fats from avocados, nuts, and olive oil."
            ]
        ),
        NutritionTopic(
            title: "Micronutrients 🍎",
            details: """
                Micronutrients, including vitamins and minerals, are essential for growth, immune function, and overall well-being. These nutrients don't provide energy but play vital roles in bodily processes like blood clotting, bone formation, and nerve signaling.
            """,
            keyPoints: [
                "Vitamins (like C, D, and E) are necessary for immunity and cell repair.",
                "Minerals (like calcium and iron) support bone health and oxygen transport.",
                "A varied diet ensures you receive all essential micronutrients."
            ],
            tips: [
                "Consume colorful fruits and vegetables to cover a wide range of vitamins and minerals.",
                "Pair iron-rich foods (spinach, beans) with Vitamin C-rich foods (citrus fruits) for better absorption.",
                "Include fortified foods or supplements if dietary gaps exist."
            ]
        ),
        NutritionTopic(
            title: "Plant-Based Diet 🥗",
            details: """
                A plant-based diet focuses on whole, minimally processed foods derived from plants. It emphasizes fruits, vegetables, grains, nuts, and legumes while reducing or eliminating animal products. This approach is linked to reduced risks of heart disease, diabetes, and certain cancers.
            """,
            keyPoints: [
                "Rich in fiber, vitamins, and antioxidants.",
                "May support weight management and lower cholesterol levels.",
                "Environmentally sustainable and promotes animal welfare."
            ],
            tips: [
                "Start small by incorporating plant-based meals a few days a week.",
                "Experiment with meat substitutes like tofu, tempeh, or jackfruit.",
                "Plan meals around whole grains, beans, and a variety of vegetables."
            ]
        ),
        NutritionTopic(
            title: "Ketogenic Diet 🥓",
            details: """
                The ketogenic diet is a low-carbohydrate, high-fat diet that shifts the body into ketosis, burning fat for energy instead of carbohydrates. It is commonly used for weight loss and improved blood sugar regulation but requires careful planning to ensure nutrient balance.
            """,
            keyPoints: [
                "Reduces carb intake to 20–50 grams per day.",
                "Encourages consumption of healthy fats and moderate protein.",
                "Can improve insulin sensitivity and mental clarity for some."
            ],
            tips: [
                "Avoid high-carb foods like bread, pasta, and sugary snacks.",
                "Choose healthy fats from avocados, nuts, and seeds.",
                "Monitor progress and adjust the diet to suit your energy needs."
            ]
        ),
        NutritionTopic(
            title: "Mediterranean Diet 🍇",
            details: """
                Inspired by the traditional eating habits of Mediterranean countries, this diet prioritizes whole grains, fresh produce, lean proteins, and healthy fats. It has been praised for supporting heart health, reducing inflammation, and promoting longevity.
            """,
            keyPoints: [
                "High consumption of fruits, vegetables, and olive oil.",
                "Moderate intake of fish, poultry, and dairy.",
                "Low consumption of red meat and processed foods."
            ],
            tips: [
                "Incorporate olive oil as your main cooking fat.",
                "Include fatty fish like salmon and mackerel weekly for omega-3s.",
                "Enjoy meals with whole-grain bread, hummus, and fresh vegetables."
            ]
        ),
        NutritionTopic(
            title: "Gut Health 🦠",
            details: """
                A healthy gut microbiome is essential for digestion, nutrient absorption, and immunity. A balanced diet rich in fiber and fermented foods can help maintain a thriving gut ecosystem and improve overall health.
            """,
            keyPoints: [
                "Probiotics introduce beneficial bacteria into your system.",
                "Prebiotics feed the bacteria already in your gut.",
                "Avoiding unnecessary antibiotics can preserve gut health."
            ],
            tips: [
                "Include fermented foods like yogurt, kimchi, and kombucha in your diet.",
                "Eat fiber-rich foods like bananas, asparagus, and whole grains.",
                "Limit processed foods that may disrupt gut bacteria."
            ]
        ),
        NutritionTopic(
            title: "Meal Timing 🕒",
            details: """
                When you eat can be just as important as what you eat. Regular meal timing helps stabilize blood sugar levels, supports metabolic health, and improves energy regulation throughout the day.
            """,
            keyPoints: [
                "Consistent meal times align with your body’s circadian rhythm.",
                "Late-night eating can disrupt digestion and sleep quality.",
                "Structured meal patterns prevent overeating and promote satiety."
            ],
            tips: [
                "Plan meals at the same time daily to regulate hunger and energy.",
                "Avoid large meals close to bedtime for better digestion and sleep.",
                "Try intermittent fasting to explore potential health benefits."
            ]
        ),
        NutritionTopic(
            title: "Sports Nutrition 🏋️",
            details: """
                Nutrition tailored to physical activity is crucial for maximizing performance, enhancing recovery, and preventing injuries. A balance of macronutrients, hydration, and timing ensures your body performs at its peak.
            """,
            keyPoints: [
                "Carbs provide energy for workouts, while protein aids recovery.",
                "Hydration is essential to prevent fatigue and maintain focus.",
                "Post-exercise nutrition replenishes glycogen and repairs muscles."
            ],
            tips: [
                "Fuel up with a carb-rich snack 1–2 hours before exercise.",
                "Stay hydrated during workouts with water or sports drinks for endurance.",
                "Consume a mix of protein and carbs within 30 minutes after exercising."
            ]
        ),
        NutritionTopic(
            title: "Healthy Snacking 🥜",
            details: """
                Snacking can be a great way to maintain energy and curb hunger between meals if done wisely. Choosing nutrient-dense snacks prevents overeating and provides sustained energy throughout the day.
            """,
            keyPoints: [
                "Avoid snacks high in sugar and empty calories.",
                "Combine protein and fiber to feel full longer.",
                "Prepare snacks in advance to make healthier choices easier."
            ],
            tips: [
                "Choose options like nuts, fruit with nut butter, or Greek yogurt with berries.",
                "Avoid processed snacks like chips and cookies when possible.",
                "Prep portion-controlled snack packs to avoid overeating."
            ]
        )
    ]
}
