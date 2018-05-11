import 'package:flutter/material.dart';

// 引入english_words.dart 软件包
import 'package:english_words/english_words.dart';

//Main 函数，程序的入口
//main函数使用了(=>)符号, 这是Dart中单行函数或方法的简写。
void main() => runApp(new MyApp());


//该应用程序继承了 StatelessWidget，这将会使应用本身也成为一个widget。
//在Flutter中，大多数东西都是widget，包括对齐(alignment)、填充(padding)和布局(layout)

//Stateless widgets 是不可变的, 这意味着它们的属性不能改变 - 所有的值都是最终的
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //随机获取一个英文单词
//    final wordPair = new WordPair.random();
    return MaterialApp(
//      title: "Hello Flutter App",
//      //Scaffold 是 Material library 中提供的一个widget,
//      //它提供了默认的导航栏、标题和包含主屏幕widget树的body属性。widget树可以很复杂。
//      //widget的主要工作是提供一个build()方法来描述如何根据其他较低级别的widget来显示自己。
//      home: new Scaffold(
//        appBar: new AppBar(
//          title: new Text("Welcome Flutter App"),
//        ),
//
//        //本示例中的body的widget树中包含了一个Center widget,
//        //Center widget又包含一个 Text 子widget。
//        //Center widget可以将其子widget树对齐到屏幕中心
//        body: new Center(
////          child: new Text("Hello world!!!"),
////          child: new Text(wordPair.asPascalCase),
//          child: new RandomWords(),
//        ),
//      ),
      title: "Startup Name Generator",
      home: new RandomWords(),
    );
  }
}

/*
 * Stateful widgets 持有的状态可能在widget生命周期中发生变化. 实现一个 stateful widget 至少需要两个类:
 *   一个 StatefulWidget类。
 *   一个 State类。 StatefulWidget类本身是不变的，但是 State类在widget生命周期中始终存在.
 *
 *   这一步
 *   添加一个有状态的widget-RandomWords，它创建其State类RandomWordsState。State类将最终为widget维护建议的和喜欢的单词对。
 *
 */
class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RandomWordsState();
  }
}

class RandomWordsState extends State<RandomWords> {

  //添加一个_suggestions列表以保存建议的单词对
  //该变量以下划线（_）开头，在Dart语言中使用下划线前缀标识符，会强制其变成私有的。
  final _suggestions = <WordPair>[];

  //添加一个biggerFont变量来增大字体大小
  final _biggerFont = const TextStyle(fontSize: 18.0);

  //当用户点击列表中的条目，切换其“收藏”状态时，将该词对添加到或移除出“收藏夹”

  //添加一个 _saved Set(集合) 到RandomWordsState
  //这个集合存储用户喜欢（收藏）的单词对。 在这里，Set比List更合适，因为Set中不允许重复的值。
  final _saved = new Set<WordPair>();

  //添加一个 _buildSuggestions() 函数. 此方法构建显示建议单词对的ListView
  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
      // 在偶数行，该函数会为单词对添加一个ListTile row.
      // 在奇数行，该行书湖添加一个分割线widget，来分隔相邻的词对。
      // 注意，在小屏幕上，分割线看起来可能比较吃力。
      itemBuilder: (context, i) {
        // 在每一列之前，添加一个1像素高的分隔线widget
        // odd: 奇数
        if(i.isOdd) return new Divider();
        // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
        // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
        final index = i ~/ 2;
        // 如果是建议列表中最后一个单词对
        if(index >= _suggestions.length) {
          // ...接着再生成10个单词对，然后添加到建议列表
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      }
    );
  }

  //对于每一个单词对，_buildSuggestions函数都会调用一次_buildRow
  //这个函数在ListTile中显示每个新词对，这使您在下一步中可以生成更漂亮的显示行
  //添加一个_buildRow函数 :
  Widget _buildRow(WordPair pair){

    //判断是否添加到收藏
    final isSaved = _saved.contains(pair);

      return new ListTile(
        title: new Text(
            pair.asPascalCase,
            style: _biggerFont,
        ),
        //被拖动
        trailing: new Icon(
            isSaved ? Icons.favorite : Icons.favorite_border,
            color: isSaved ? Colors.red : null,
        ),
        //添加点击交互
        onTap: (){
          ///在Flutter的响应式风格的框架中，调用setState() 会为State对象触发build()方法，从而导致对UI的更新
          setState(() {
            if(isSaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    //随机获取一个英文单词
//    final wordPair = new WordPair.random();
//    return new Text(wordPair.asPascalCase);
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Start Up Name Generator"),
          //添加一个菜单按钮
          actions: <Widget>[new IconButton(icon: new Icon(Icons.list), onPressed: _onMenuClick)],
        ),
        body: _buildSuggestions(),
    );

  }

  ///菜单点击
  void _onMenuClick(){
    Navigator.of(context).push(
      new MaterialPageRoute(
          builder: (context) {
            final tiles = _saved.map(
                (pair) {
                  return new ListTile(
                    title: new Text(
                      pair.asPascalCase,
                      style: _biggerFont,
                    ),
                  );
                }
            );

            final divider = ListTile.divideTiles(
                context: context,
                tiles: tiles
            ).toList();

            return new Scaffold(
              appBar: new AppBar(
                title: new Text("Favorite List"),
              ),
              body: new ListView(children: divider,),
            );
          }
      )
    );
  }

}
