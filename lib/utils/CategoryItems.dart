import 'package:agri_connect/constants/image_strings.dart';
import 'package:flutter/material.dart';



class CategoryItems extends StatelessWidget {
  const CategoryItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                CircleAvatar(backgroundImage: AssetImage(EImages.CerealsAndGrains), radius: 35,),
                Text('Cereals and Grains', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10),),
              ],
            ),
            Column(
              children: [
                CircleAvatar(backgroundImage: AssetImage(EImages.Fruits), radius: 35,),
                Text('Fruits', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10),),
              ],
            ),
            Column(
              children: [
                CircleAvatar(backgroundImage: AssetImage(EImages.Vegetables), radius: 35,),
                Text('Vegetables', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10),),
              ],
            ),
            Column(
              children: [
                CircleAvatar(backgroundImage: AssetImage(EImages.Legumes), radius: 35,),
                Text('Legumes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10),),
              ],
            ),
          ],
        ),
        SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                CircleAvatar(backgroundImage: AssetImage(EImages.NutsAndSeeds), radius: 35,),
                Text('Nuts and Seeds', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10),),
              ],
            ),
            Column(
              children: [
                CircleAvatar(backgroundImage: AssetImage(EImages.DairyProducts), radius: 35,),
                Text('Dairy Products', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10),),
              ],
            ),
            Column(
              children: [
                CircleAvatar(backgroundImage: AssetImage(EImages.HerbsAndSpices), radius: 35,),
                Text('Herbs and Spices', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10),),
              ],
            ),
            Column(
              children: [
                CircleAvatar(backgroundImage: AssetImage(EImages.Manures), radius: 35,),
                Text('Manures', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10),),
              ],
            ),
          ],
        ),
        SizedBox(height: 30,),
      ],
    );
  }
}