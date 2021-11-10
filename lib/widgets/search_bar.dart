import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final String? hintText;
  const SearchBar({
    Key? key,
    this.hintText,
    required TextEditingController search,
  })  : _search = search,
        super(key: key);

  final TextEditingController _search;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: size.height * 0.1,
        child: Stack(
          alignment: AlignmentDirectional.centerEnd,
          children: [
            SizedBox(
              child: TextField(
                controller: _search,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.only(right: 50),
                    hintText: hintText,
                    hintTextDirection: TextDirection.rtl),
              ),
              width: size.width * 0.6,
            ),
            const Positioned(
              child: Icon(Icons.search),
              right: 15,
            ),
          ],
        ),
      ),
    );
  }
}
