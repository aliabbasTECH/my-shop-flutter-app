import 'package:flutter/material.dart';
import 'package:myshop2/providers/products.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  // this is used for  automaticly submit and jump to next input field.  there, it targets price input from title input
  final _discriptionFocusNode = FocusNode();
  //  this is used for  automaticly submit and jump to next input field. there, it targets Discription input from price input
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isloading = false;
  var _initValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageUrl": "",
  };
  var _editProduct = Product(
      id: null,
      title: "",
      description: "",
      price: 0.0,
      imageUrl: "",
      // authToken: ""
      );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productID = ModalRoute.of(context)?.settings.arguments as dynamic;
      if (productID != null) {
        _editProduct =
            Provider.of<Products>(context, listen: false).findById(productID);
        _initValues = {
          "title": _editProduct.title,
          "discription": _editProduct.description,
          "price": _editProduct.price.toString(),
          "imgeUrl": "",
        };
        _imageUrlController.text = _editProduct.imageUrl;
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _discriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith("http") &&
              !_imageUrlController.text.startsWith("https")) ||
          (!_imageUrlController.text.endsWith(".png") &&
              !_imageUrlController.text.endsWith(".jpg") &&
              !_imageUrlController.text.endsWith(".jpeg"))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isloading = true;
    });
    if (_editProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editProduct);
      } catch (err) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("An error occurred!"),
                  content: Text(err.toString()),
                  actions: <Widget>[
                    TextButton(
                        child: Text("ok"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ));
      }
      // finally{
      //   setState(() {
      //     _isloading = false;
      //   });
      //    Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isloading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Product"), actions: [
        IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: Icon(Icons.save))
      ]),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues["title"],
                        decoration: InputDecoration(labelText: 'title'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Plese Provide Value";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                            id: _editProduct.id,
                            title: value as dynamic,
                            price: _editProduct.price,
                            description: _editProduct.description,
                            imageUrl: _editProduct.imageUrl,
                            isFavorite: _editProduct.isFavorite,
                            // authToken: _editProduct.authToken  // this is a way off add authtoken in Single product where Product Favorit is saved and there are other way too! .
                          );
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues["price"],
                        decoration: InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Plese enter the price!";
                          }
                          if (double.tryParse(value) == null) {
                            return "plese enter the valid number"; // validate if user enter value insted of number like enter alphabat  etc, it will give error
                          }
                          if (double.parse(value) <= 0) {
                            return 'please enter value above 0'; // double.parse conver the value in double and validate if value is less then or equal to zero it will give error
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_discriptionFocusNode);
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                            id: _editProduct.id,
                            title: _editProduct.title,
                            description: _editProduct.description,
                            price: double.parse(value!),
                            imageUrl: _editProduct.imageUrl,
                            isFavorite: _editProduct.isFavorite,
                            // authToken: _editProduct.authToken,
                          );
                        },
                      ),
                      TextFormField(
                          initialValue: _initValues["discription"],
                          decoration: InputDecoration(labelText: 'Discription'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please entert Discription !";
                            }
                            if (value.length < 10) {
                              return "Please enter atleat 10 charactors";
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_imageUrlFocusNode);
                          },
                          focusNode: _discriptionFocusNode,
                          onSaved: (value) {
                            _editProduct = Product(
                              id: _editProduct.id,
                              title: _editProduct.title,
                              description: value as String,
                              price: _editProduct.price,
                              imageUrl: _editProduct.imageUrl,
                              isFavorite: _editProduct.isFavorite,
                              // authToken: _editProduct.authToken
                            );
                          }),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                              width: 110,
                              height: 110,
                              margin: EdgeInsets.only(top: 8, right: 10),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: _imageUrlController.text.isEmpty
                                  ? Text("enter the url")
                                  : FittedBox(
                                      child: Image.network(_imageUrlController.text),
                                      fit: BoxFit.fill,
                                    )),
                          Expanded(
                              child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Image URL'),
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.done,
                                  controller: _imageUrlController,
                                  focusNode: _imageUrlFocusNode,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please entert Image url !";
                                    }
                                    if (!value.startsWith("http") &&
                                        !value.startsWith("https")) {
                                      return "valid enter a valid URL.";
                                    }
                                    if (!value.endsWith(".png") &&
                                        !value.endsWith(".jpg") &&
                                        !value.endsWith("jpeg")) {
                                      return "enter valid formate like (png , jpg ,jpeg ) ";
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (_) => _saveForm(),
                                  onSaved: (value) {
                                    _editProduct = Product(
                                      id: _editProduct.id,
                                      title: _editProduct.title,
                                      description: _editProduct.description,
                                      price: _editProduct.price,
                                      imageUrl: value as dynamic,
                                      isFavorite: _editProduct.isFavorite,
                                      // authToken: _editProduct.authToken
                                    );
                                  })),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
