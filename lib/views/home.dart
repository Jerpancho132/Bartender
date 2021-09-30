import 'package:app/views/Widgets/cocktail_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E5F2),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.whatshot),
            SizedBox(width: 10),
            Text('Popular Drinks'),
          ],
        ),
      ),
      body: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 16),
          children: const [
            //A function will be inserted here to grab drinks from database instead of harcoding
            //cocktail cards.
            CocktailCard(
              cocktailName: 'Long Island Ice Tea',
              thumbnailUrl:
                  'https://www.hangoverweekends.co.uk/media/15498/long-island-iced-tea.jpg?width=236px&height=418px',
            ),
            CocktailCard(
              cocktailName: 'Pina Colada',
              thumbnailUrl:
                  'https://www.hangoverweekends.co.uk/media/15501/pina_colada_cocktail.png?width=243&height=350',
            ),
            CocktailCard(
              cocktailName: 'Margarita',
              thumbnailUrl:
                  'https://www.hangoverweekends.co.uk/media/15502/margarita.jpg?width=298px&height=412px',
            ),
            CocktailCard(
              cocktailName: 'Mai Tai',
              thumbnailUrl:
                  'https://www.hangoverweekends.co.uk/media/15506/mm-cocktail-guide-maitai-590x375.jpg?width=434px&height=276px',
            ),
            CocktailCard(
              cocktailName: 'Mojito',
              thumbnailUrl:
                  'https://www.hangoverweekends.co.uk/media/15505/mojito.jpg?width=500&height=375',
            ),
            CocktailCard(
              cocktailName: 'Cosmopolitan',
              thumbnailUrl:
                  'https://www.hangoverweekends.co.uk/media/15507/gallery-1430408520-dmg-cosmopolitan-cocktail-001.jpg?width=330px&height=407px',
            ),
          ]),
    );
  }
}
