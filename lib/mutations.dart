class QueryMutation {
  String addImage(String image) {
    return """
      mutation{
          uploadPhotoEvent(image: "data:image/jpeg;base64,$image"){
            message, status
          }
      }
    """;
  }
}