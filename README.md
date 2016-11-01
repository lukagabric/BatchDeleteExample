# BatchDeleteExample
iOS Batch Delete

Check AppDelegate for the sample.

Sample implementation: first clear the database, fill it with many duplicate object and then batch delete all duplicates, leaving only unique objects (only one object with given productId).

  //just cleanup the database
  self.deleteAllObjects(context: context)
              
  //Simulates a random number of duplicates (objects with the same productId), that can be distinguished by the productName
  //e.g. one product could have    productId = "id.1" and productName = "Product 1.1",
  //and a duplicate will also have productId = "id.1" but productName = "Product 1.2"
  self.insertDuplicates(context: context)
  try! context.save()
   
  //prints all duplicates from the view context
  self.refreshAndPrintProducts()
  
  //removes all duplicates
  self.deleteDuplicates(context: context)
  try! context.save()
  
  //prints all unique objects
  self.refreshAndPrintProducts()
