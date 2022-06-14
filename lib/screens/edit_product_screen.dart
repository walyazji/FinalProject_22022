import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: '', title: '', description: '', price: 0.00, imageUrl: '');

  var _initialValues = {
    'id': '',
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
    
  }
  
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final prodId = ModalRoute.of(context)!.settings.arguments as String;
      if (prodId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(prodId);
        _initialValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    super.didChangeDependencies();
    _isInit = false;
    }
  }
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (_isInit) {
  //     final productId = ModalRoute.of(context)!.settings.arguments as String;
  //     if (productId != '') {
  //       _editedProduct =
  //           Provider.of<Products>(context, listen: false).findById(productId);
  //       _initialValues = {
  //         'title': _editedProduct.title,
  //         'price': _editedProduct.price.toString(),
  //         'description': _editedProduct.description,
  //         'imageUrl': '',
  //       };
  //       _imageUrlController.text = _editedProduct.imageUrl;
  //     }
  //     _isInit = false;
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    _descriptionFocusNode.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((_imageUrlController.text.startsWith('http') && 
              _imageUrlController.text.startsWith('https')) &&
          (_imageUrlController.text.endsWith('.png')) &&
              _imageUrlController.text.endsWith('.jpg') &&
              _imageUrlController.text.endsWith('.jpeg')) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != '') {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
          Navigator.of(context).pop(); 
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('An Error Occurred'),
                  content: const Text('Something went wrong'),
                  actions: [
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Okey!'))
                  ],
                ));
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initialValues['title'],
                      decoration: const InputDecoration(labelText: 'Title'),

                      textInputAction:
                          TextInputAction.next, //بتعطيني علامة نيكست بالكيبورد
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            price: _editedProduct.price,
                            title: value!,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      initialValue: _initialValues['price'],
                      decoration: const InputDecoration(labelText: 'Price'),
                      focusNode: _priceFocusNode,
                      textInputAction:
                          TextInputAction.next, //بتعطيني علامة نيكست بالكيبورد
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.tryParse(value)! <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            price: double.parse(value!),
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      initialValue: _initialValues['description'],
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length <= 10) {
                          'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            price: _editedProduct.price,
                            title: _editedProduct.title,
                            description: value!,
                            imageUrl: _editedProduct.imageUrl);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                )),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _imageUrlController,
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            focusNode: _imageUrlFocusNode,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a image URL.';
                              }
                              if ((!value.startsWith('https')) ||
                                  (!value.startsWith('http'))) {
                                return 'Please enter a valid URL.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid URL.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                  id: _editedProduct.id,
                                  price: _editedProduct.price,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  imageUrl: value!,
                                  isFavorite: _editedProduct.isFavorite);
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                key: _formKey,
              ),
            ),
    );
  }
}
