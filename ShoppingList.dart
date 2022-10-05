class ShoppingList {
  int id;
  String name;
  int sum;

  ShoppingList(this.id, this.name, this.sum);

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'sum': sum};
  }

  @override
  String toString() {
    return "id : $id\nname : $name\nsum : $sum";
  }
}
