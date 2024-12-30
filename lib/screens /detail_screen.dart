import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:recipe_app/constants/share.dart';
import 'package:recipe_app/constants/show_table.dart';
import 'package:recipe_app/constants/start_cooking.dart';

import '../components/circle_button.dart';
import '../components/custom_clip_path.dart';
import '../components/ingredient_list.dart';
import '../constants/show_detail_dialog.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    var myBox=Hive.box('saved');
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    String time = widget.item['totalTime'].toString();

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: h * 0.44,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.item['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: h * 0.04,
                  left: w * 0.05,
                  child: const CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    child: BackButton(color: Colors.white),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    widget.item['label'],
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text("$time min"),
                  SizedBox(height: h * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap:(){
                          ShareRecipe.share(widget.item['url']);
                        },
                        child: const CircleButton(
                          icon: Icons.share,
                          label: 'Share',
                        ),
                      ),
                      ValueListenableBuilder(valueListenable: myBox.listenable(),
                          builder: (context,box,_){
                            String key=widget.item['label'];
                            bool saved=myBox.containsKey(key);
                            if(saved){
                              return GestureDetector(
                                onTap:(){
                                  myBox.delete(key);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Text('Recipe deleted'))
                                  );
                                },
                                child: const CircleButton(
                                  icon: Icons.bookmark,
                                  label: 'Saved',
                                ),
                              );
                            }
                            else{
                              return GestureDetector(
                                onTap:(){
                                  myBox.put(key, key);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          duration: Duration(seconds: 1),
                                          content: Text('Recipe saved successfully'))
                                  );
                                },
                                child: const CircleButton(
                                  icon: Icons.bookmark_border,
                                  label: 'Save',
                                ),
                              );
                            }
                          }),
                      GestureDetector(
                        onTap:(){
                          ShowDialog.showCalories(widget.item['totalNutrients'], context);
                        },
                        child:const CircleButton(
                          icon: Icons.monitor_heart_outlined,
                          label: 'Calories',
                        ),
                      ),
                      GestureDetector(
                        onTap:(){
                          ShowTable.showTable(context);
                        },
                        child: const CircleButton(
                          icon: Icons.table_chart_outlined,
                          label: 'Unit chart',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Direction',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: w * 0.06,
                        ),
                      ),
                      SizedBox(
                        width: w * 0.34,
                        child: ElevatedButton(
                          onPressed: () {
                            StartCooking.startCooking(widget.item['url']);
                          },
                          child: const Text('Start'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.02),
                  Container(
                    height: h * 0.07,
                    width: w,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ClipPath(
                            clipper: CustomClipPath(),
                            child: Container(
                              color: Colors.redAccent,
                              child: Center(
                                child: Text(
                                  'Ingredients Required',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: w * 0.05,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.white,
                            child: const Center(
                              child: Text('    6\nItems'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: h*1.8,
                    child: IngredientList(
                      ingredients: widget.item['ingredients'],
                  ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
