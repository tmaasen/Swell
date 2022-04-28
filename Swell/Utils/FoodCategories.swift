//
//  FoodCategories.swift
//  Swell
//
//  Created by Tanner Maasen on 3/31/22.
//

import Foundation

class FoodCategories {
    static var aggregatedCategories = ["Baby", "Baking", "Beef", "Beverages", "Bread", "Breakfast", "Butter", "Cheese", "Chewing Gum & Mints", "Chips", "Coffee", "Condiments, Dressings, & Oils", "Cookies & Biscuits", "Dairy", "Earthy and Foreign", "Fish", "Fries", "Fruit", "Herbs and Spices", "Mexican", "Miscellaneous", "Noodles", "Nuts & Seeds", "Pizza", "Popcorn", "Pork", "Poultry & Eggs", "Salad", "Sandwich", "Soups, Sauces, and Gravies", "Supplements", "Sushi", "Sweets", "Vegetables", "Yogurt and Ice Cream", "Alcohol"]
    static var categoryDict: [String: [String]] =
        [
            "Alcohol": ["Alchol","Alcoholic Beverages", "Beer"],
            "Supplements": ["Amino Acid Supplements", "Antioxidant Supplements", "Digestive & Fiber Supplements", "Energy, Protein & Muscle Recovery Drinks", "Fats Edible", "Fatty Acid Supplements", "Green Supplements", "Health Care", "Herbal Supplements", "Meal Replacement Supplements", "Specialty Formula Supplements", "Vitamins"],
            "Fish": ["Aquatic Invertebrates/Fish/Shellfish/Seafood Combination", "Finfish and Shellfish Products", "Fish  Prepared/Processed", "Fish  Unprepared/Unprocessed", "Fish ‚Äì Prepared/Processed", "Fish ‚Äì Unprepared/Unprocessed", "Fish & Seafood", "Frozen Fish & Seafood", "Canned Tuna", "Canned Seafood", "Shellfish Prepared/Processed", "Shellfish Unprepared/Unprocessed"],
            "Baby": ["Baby/Infant  Foods/Beverages", "Baby/Infant ‚Äì Foods/Beverages", "Baby Foods", "Childcare", "Children's Natural Remedies", "Children's Nutritional Supplements"],
            "Pork": ["Bacon, Sausages & Ribs", "Pork Products", "Frozen Bacon, Sausages & Ribs", "Frozen Sausages, Hotdogs & Brats", "Pork - Prepared/Processed", "Pork Sausages - Prepared/Processed", "Sausages, Hotdogs & Brats"],
            "Baking": ["Baking", "Baking Accessories", "Baking Additives & Extracts", "Baking Decorations & Dessert Toppings", "Baking/Cooking Mixes (Perishable)", "Baking/Cooking Mixes (Shelf Stable)", "Baking/Cooking Mixes/Supplies", "Baking/Cooking Mixes/Supplies Variety Packs", "Baking/Cooking Supplies (Shelf Stable)", "Baked Products", "Croissants, Sweet Rolls, Muffins & Other Pastries", "Cake, Cookie & Cupcake Mixes", "Cakes - Sweet (Frozen)", "Cakes - Sweet (Shelf Stable)", "Cakes, Cupcakes, Snack Cakes", "Savoury Bakery Products", "Pies/Pastries - Sweet (Shelf Stable)", "Pies/Pastries/Pizzas/Quiches - Savoury (Frozen)", "Sweet Bakery Products", "Stuffing"],
            "Beef": ["Beef - Prepared/Processed", "Beef Products", "Frozen Patties and Burgers", "Meat Substitutes", "Meat/Poultry/Other Animals  Prepared/Processed", "Meat/Poultry/Other Animals  Unprepared/Unprocessed", "Meat/Poultry/Other Animals ‚Äì Prepared/Processed", "Meat/Poultry/Other Animals ‚Äì Unprepared/Unprocessed", "Meat/Poultry/Other Animals Sausages  Prepared/Processed", "Meat/Poultry/Other Animals Sausages ‚Äì Prepared/Processed", "Other Frozen Meats", "Canned Meat", "Chili & Stew", "Lamb, Veal, and Game Products", "Other Meats"],
            "Cookies & Biscuits": ["Biscuits/Cookies", "Biscuits/Cookies (Shelf Stable)", "Cookies & Biscuits"],
            "Bread": ["Bread", "Bread & Muffin Mixes", "Bread/Bakery Products Variety Packs", "Crusts & Dough", "Dough Based Products / Meals", "Dough Based Products / Meals - Not Ready to Eat - Savoury (Frozen)", "Dough Based Products / Meals - Not Ready to Eat - Savoury (Shelf Stable)", "Dried Breads (Shelf Stable)", "Frozen Bread & Dough", "Breads & Buns"],
            "Breakfast": ["Breakfast Drinks", "Breakfast Foods", "Breakfast Sandwiches, Biscuits & Meals", "Frozen Breakfast Sandwiches, Biscuits & Meals", "Frozen Pancakes, Waffles, French Toast & Crepes", "Pancakes, Waffles, French Toast & Crepes", "Cereal", "Cereal/Muesli Bars", "Cereals Products - Not Ready to Eat (Shelf Stable)", "Cereals Products - Ready to Eat (Shelf Stable)", "Breakfast Cereals", "Processed Cereal Products"],
            "Butter": ["Butter & Spread", "Butter/Butter Substitutes", "Nut & Seed Butters"],
            "Sweets": ["Candy", "Sweets", "Chocolate", "Confection & Snacks", "Confectionery Products", "Desserts/Dessert Sauces/Toppings", "Gelatin, Gels, Pectins & Desserts", "Other Frozen Desserts", "Puddings & Custards", "Sweet Spreads", "Syrups & Molasses", "Sugars/Sugar Substitute Products", "Granulated, Brown & Powdered Sugar", "Snacks", "Snack, Energy & Granola Bars", "Wholesome Snacks", "Other Snacks", "Flavored Snack Crackers"],
            "Cheese": ["Cheese", "Cheese/Cheese Substitutes", "Processed Cheese & Cheese Novelties"],
            "Chewing Gum & Mints": ["Chewing Gum & Mints"],
            "Chips": ["Chips, Pretzels & Snacks", "Crackers & Biscotti", "Dips & Salsa", "Chips/Crisps/Snack Mixes - Natural/Extruded (Shelf Stable)"],
            "Coffee": ["Coffee", "Coffee/Tea/Substitutes", "Other Drinks"],
            "Condiments, Dressings, & Oils": ["Fats & Oils", "Condiments, Oils & Dressing", "Dressings/Dips (Shelf Stable)", "Honey", "Jam, Jelly & Fruit Spreads", "Ketchup, Mustard, BBQ & Cheese Sauce", "Oils Edible", "Vinegars/Cooking Wines", "Sauces/Spreads/Dips/Condiments", "Other Condiments", "Vegetable & Cooking Oils"],
            "Dairy": ["Dairy/Egg Based Products / Meals", "Milk", "Milk Additives", "Milk/Milk Substitutes", "Dairy and Egg Products"],
            "Salad": ["Deli Salads", "Salad Dressing & Mayonnaise"],
            "Beverages": ["Drinks", "Drinks Flavoured - Ready to Drink", "Beverages", "Sport Drinks", "Iced & Bottle Tea", "Tea Bags", "Non Alcoholic Beverages  Not Ready to Drink", "Non Alcoholic Beverages  Ready to Drink", "Non Alcoholic Beverages ‚Äì Not Ready to Drink", "Non Alcoholic Beverages ‚Äì Ready to Drink", "Powdered Drinks", "Soda"],
            "Poultry & Eggs": ["Egg Based Products / Meals - Not Ready to Eat (Frozen)", "Eggs & Egg Substitutes", "Poultry Products", "Frozen Poultry, Chicken & Turkey", "Poultry, Chicken & Turkey"],
            "Miscellaneous": ["Meals, Entrees, and Side Dishes", "Entrees, Sides & Small Meals", "Sausages and Luncheon Meals", "Frozen Appetizers & Hors D'oeuvres", "Food/Beverage/Tobacco Variety Packs", "Cooked & Prepared", "Frozen Dinners & Entrees", "Frozen Prepared Sides", "Lunch Snacks & Combinations", "Prepared/Preserved Foods Variety Packs", "Fast Foods", "Restaurant Foods", "Miscellanious", "Ready-Made Combination Meals", "Grain Based Products / Meals", "Grain Based Products / Meals - Not Ready to Eat - Savoury (Shelf Stable)", "Grains", "Flavored Rice Dishes", "Rice", "Flour - Cereal/Pulse (Shelf Stable)", "Flours & Corn Meal", "Grains/Flour"],
            "Fries": ["French Fries, Potatoes & Onion Rings"],
            "Fruit": ["Fruit and Fruit Juices", "Fruit  Prepared/Processed", "Fruit - Prepared/Processed (Shelf Stable)", "Fruit ‚Äì Prepared/Processed", "Fruit & Vegetable Juice, Nectars & Fruit Drinks", "Canned Fruit", "Fruit/Nuts/Seeds Combination", "Fruits, Vegetables & Produce", "Frozen Fruit & Fruit Juice Concentrates"],
            "Soups, Sauces, and Gravies": ["Soups, Sauces, and Gravies", "Gravy Mix", "Oriental, Mexican & Ethnic Sauces", "Other Cooking Sauces", "Canned Condensed Soup", "Canned Soup", "Other Soups", "Prepared Pasta & Pizza Sauces", "Prepared Soups", "Sauces - Cooking (Shelf Stable)", "Soups - Prepared (Shelf Stable)"],
            "Herbs and Spices": ["Spices and Herbs", "Herbs & Spices", "Herbs/Spices/Extracts", "Seasoning Mixes, Salts, Marinades & Tenderizers"],
            "Mexican": ["Mexican Dinner Mixes"],
            "Nuts & Seeds": ["Nut and Seed Products", "Nuts/Seeds  Prepared/Processed", "Nuts/Seeds  Unprepared/Unprocessed (Shelf Stable)", "Nuts/Seeds - Prepared/Processed (Shelf Stable)", "Nuts/Seeds ‚Äì Prepared/Processed", "Nuts/Seeds ‚Äì Unprepared/Unprocessed (Shelf Stable)", "Other Grains & Seeds"],
            "Noodles": ["Cereal Grains and Pasta", "Pasta by Shape & Type", "Pasta Dinners", "Pasta/Noodles", "Pasta/Noodles - Not Ready to Eat (Frozen)", "All Noodles", "Pastry Shells & Fillings"],
            "Pizza": ["Pizza", "Pizza Mixes & Other Dry Dinners"],
            "Earthy and Foreign": ["Plant Based Milk", "American Indian/Alaska Native Foods", "Plant Based Water"],
            "Popcorn": ["Popcorn (Shelf Stable)", "Popcorn, Peanuts, Seeds & Related Snacks"],
            "Sandwich": ["Prepared Subs & Sandwiches", "Prepared Wraps and Burittos", "Other Deli", "Pepperoni, Salami & Cold Cuts", "Sandwiches/Filled Rolls/Wraps"],
            "Sushi": ["Sushi"],
            "Vegetables": ["Vegetable and Lentil Mixes", "Vegetable Based Products / Meals", "Vegetable Based Products / Meals - Not Ready to Eat (Frozen)", "Vegetables  Prepared/Processed", "Vegetables  Unprepared/Unprocessed (Frozen)", "Vegetables  Unprepared/Unprocessed (Shelf Stable)", "Vegetables - Prepared/Processed (Frozen)", "Vegetables - Prepared/Processed (Shelf Stable)", "Vegetables ‚Äì Prepared/Processed", "Vegetables ‚Äì Unprepared/Unprocessed (Frozen)", "Vegetables ‚Äì Unprepared/Unprocessed (Shelf Stable)", "Vegetarian Frozen Meats", "Vegetables and Vegetable Products", "Pre-Packaged Fruit & Vegetables", "Legumes and Legume Products", "Tomatoes", "Canned Vegetables", "Canned & Bottled Beans", "Peppers", "Pickles, Olives, Peppers & Relishes", "Pickles/Relishes/Chutneys/Olives", "Frozen Vegetables"],
            "Yogurt and Ice Cream": ["Yogurt", "Yogurt/Yogurt Substitutes", "Yogurt/Yogurt Substitutes (Perishable)", "Ice Cream & Frozen Yogurt", "Ice Cream/Ice Novelties (Shelf Stable)", "Cream", "Cream/Cream Substitutes"]
        ]
}
