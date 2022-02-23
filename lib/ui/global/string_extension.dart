extension StringExtension on String {
  String capitalize() {
    return split(" ").map((e) => e[0].toUpperCase() + "" + e.substring(1).toLowerCase()).join(" ");
  }

  String initials() {
    if (trim().isEmpty) {
      return "";
    } else if(split(" ").length > 1) {
      return split(" ").map((e) => e[0].toUpperCase()).toList().sublist(0, 2).join("");
    } else {
      return trim()[0].toUpperCase();
    }
  }
}
