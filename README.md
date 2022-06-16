# CoreDataDemo
this Demo for learning basic Operation for Core Data framework

## Two work with core data :- 
1. Define Data Object Model
2. Generate the classes codegen whether "Manual, class definition, category" 
3. Get a reference from core data persistent store managed object context 
4. use this reference to do all operations

### 1- Save() 
do {
   try self.context.save()
   } catch {
   print(error.localizedDescription)
  }
  
  where context is a reference from (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

### 2- Retrieve 
do {
            
            self.items = try context.fetch(Person.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            print(error.localizedDescription)
        }


### 3- Edit

// Edit name
            
            person.name = textField?.text!
            
            // save
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
            
            // retireve from data
            self.fetchPeople()


### 4- Delete 

            let presonToRemove = self.items![indexPath.row]
            
            // Remove from core data
            self.context.delete(presonToRemove)
            
            //save to data
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
            
            // retrieve the data
            self.fetchPeople()           
          
