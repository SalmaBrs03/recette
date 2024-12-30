import 'package:flutter/material.dart';
import 'package:recipe_app/components/custom_app_bar.dart';
import 'package:recipe_app/components/text_field_widget.dart';
import 'package:recipe_app/constants/search_tags.dart';
import 'package:recipe_app/screens%20/all_recipe.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(title: 'Search', back: false,),
      body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: h*.016,horizontal: w*.032
          ),
        child: Column(
          children: [
            TextFieldWidget(),
            SizedBox(height: h*.04,),

            Text('Search Tags',style: TextStyle(
              fontWeight: FontWeight.bold,fontSize: w*.06
            ),),

            Wrap(
              spacing: 8,
              children: tags.map((label) {
                return ElevatedButton(
                    onPressed:(){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>AllRecipe(recipe: label)));
                    },
                    child: Text(label)
                );

              }).toList()
            )

          ],
        ),
      ),
    );
  }
}
