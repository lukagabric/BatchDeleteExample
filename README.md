# BatchDeleteExample
[Swift 3] iOS Batch Delete

Check AppDelegate for the sample.

Sample implementation: first clear the database, fill it with many duplicate object and then batch delete all duplicates, leaving only unique objects (only one object with given productId).
```
//just cleanup the database
self.deleteAllObjects(context: context)

//Simulates a random number of duplicates (objects with the same productId), 
//that can be distinguished by the productName
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
```
In the console you'll see exactly how many objects have been inserted with unique ID as well as how many duplicates.
```
Inserted 25 objects (4 unique, 21 are duplicates that should be deleted)
```

After that all objects are listed with ID and name with a trailing ordinal e.g. Product 1.1 and Product 1.2 have the same productId = "id.1"
```
[
	id.1 	 Product 1.1, 
	id.1 	 Product 1.2, 
	id.1 	 Product 1.3, 
	id.1 	 Product 1.4, 
	id.2 	 Product 2.1, 
	id.2 	 Product 2.2, 
	id.2 	 Product 2.3, 
	id.2 	 Product 2.4, 
	id.2 	 Product 2.5, 
	id.2 	 Product 2.6, 
	id.2 	 Product 2.7, 
	id.2 	 Product 2.8, 
	id.2 	 Product 2.9, 
	id.3 	 Product 3.1, 
	id.3 	 Product 3.2, 
	id.3 	 Product 3.3, 
	id.3 	 Product 3.4, 
	id.3 	 Product 3.5, 
	id.3 	 Product 3.6, 
	id.3 	 Product 3.7, 
	id.4 	 Product 4.1, 
	id.4 	 Product 4.2, 
	id.4 	 Product 4.3, 
	id.4 	 Product 4.4, 
	id.4 	 Product 4.5]
```
When objects are deleted you will be able to match the count of deleted objects as well as the list of objects that have been kept. All duplicates are deleted and specific unique objects are listed as seen below.
```
Deleted duplicate objects count: 21
[
	id.1 	 Product 1.1, 
	id.2 	 Product 2.1, 
	id.3 	 Product 3.1, 
	id.4 	 Product 4.1]
```
