/*
 * Controller for Step 3 component (DataMover)
 *
 * @author Ximena Lasserre
 * @since Mar 2015
 */
public class DataMoverStep3ComponentController extends DataMoverComponentControllerBase{
    
    public String newTrgtLabel{get;set;}
    public String newCurrent {get;set;}
    public String currentSrcFieldToShow {get;set;}
    public String currentTrgFieldToShow {get;set;}
    public Boolean showNoRequired {get;set;}
    public Boolean showRequired {get;set;}
    public Boolean thereAreErrors {get;set;}
    public Boolean externalIdsNotFilled {get;set;}
    public Boolean requiredFieldsNotFilled {get;set;}
    public Boolean differentReferences {get;set;}
    
    /*
     * Constructor
     */
    public DataMoverStep3ComponentController(){ 
        externalIdsNotFilled = false;
        requiredFieldsNotFilled = false;
        differentReferences = false;
    }   
    
    public DataMoverPageController pageController{ 
        get;
        set { 
            if (value != null && value.initStep3Component){
                pageController = value;
                pageController.initStep3Component = false;
                populateXlr8Fields();
                if(pageController.srcTrgWrappers.size() > 0){
                    pageController.currentXlr8 = pageController.onlyXlr8Objects.get(pageController.srcTrgWrappers[0].targetLabel);
                    pageController.currentSource = pageController.onlySourceObjects.get(pageController.srcTrgWrappers[0].sourceLabel);  
                }       
            } 
            if(value != null && value.returnFromStep4){
                reconstructSrcTrgWrappers();
                if(pageController.srcTrgWrappers.size() > 0){
                    pageController.currentObject = pageController.srcTrgWrappers[0];
                }
                pageController.returnFromStep4 = false;
            }
            if(pageController.currentObject.allMatchingFieldsRequired.size() > 0){
                showRequired = true;
            }else{
                showRequired = false;
            }
        }
    }
    
     /*
      * Populate the fields info wrappers on the objects of srcTrgWrappers
      * with the info about the targets
      */
     public void populateXlr8Fields(){
        //iterate over srcTrgWrappers
        for(DataMoverObjectInfoWrapper objInfoWrap : pagecontroller.srcTrgWrappers){
            //iterate over onlyXlr8Objects
            for(String xlr8ObjLabel : pageController.onlyXlr8Objects.keySet()){
                //if the object coincides, add its fields
                if(xlr8ObjLabel == objInfoWrap.targetLabel){
                    for(String fieldWrap : pageController.onlyXlr8Objects.get(xlr8ObjLabel).objectFields.keyset()){
                        Boolean theFieldAlreadyExists = false;
                        for(String exFieldInfoWrap : objInfoWrap.allMatchingFieldsNotRequired.keyset()){

                            //if the target label matches and it hasnt been yet filled, fill it
                            if(fieldWrap == objInfoWrap.allMatchingFieldsNotRequired.get(exFieldInfoWrap).trgFieldApiName &&
                            objInfoWrap.allMatchingFieldsNotRequired.get(exFieldInfoWrap).srcFieldApiName != null){
                                theFieldAlreadyExists = true;
                            }
                        }
                        if(!theFieldAlreadyExists){
                            for(String exFieldInfoWrap : objInfoWrap.allMatchingFieldsRequired.keyset()){
                                //if the target label matches and it hasnt been yet filled, fill it
                                if(fieldWrap == objInfoWrap.allMatchingFieldsRequired.get(exFieldInfoWrap).trgFieldApiName &&
                                objInfoWrap.allMatchingFieldsRequired.get(exFieldInfoWrap).srcFieldApiName != null){
                                    theFieldAlreadyExists = true;
                                }
                            }
                        } 
                        if(!theFieldAlreadyExists){
                            DataMoverFieldInfoWrapper fieldInfoWrap = new DataMoverFieldInfoWrapper();
                            fieldInfoWrap.trgFieldLbl = pageController.onlyXlr8Objects.get(xlr8ObjLabel).objectFields.get(fieldWrap).fieldLabel;
                            fieldInfoWrap.trgFieldApiName = pageController.onlyXlr8Objects.get(xlr8ObjLabel).objectFields.get(fieldWrap).fieldApiName;
                            fieldInfoWrap.trgFieldType = pageController.onlyXlr8Objects.get(xlr8ObjLabel).objectFields.get(fieldWrap).fieldType;
                            fieldInfoWrap.trgFieldRequired = pageController.onlyXlr8Objects.get(xlr8ObjLabel).objectFields.get(fieldWrap).isFieldRequired;
                            fieldInfoWrap.trgObjApi = pageController.onlyXlr8Objects.get(xlr8ObjLabel).objectFields.get(fieldWrap).objectApiName;
                            fieldInfoWrap.trgIsNameField = pageController.onlyXlr8Objects.get(xlr8ObjLabel).objectFields.get(fieldWrap).isNameField;
                            //add the xlr8 values if there are picklists or checkboxes
                            if(pageController.onlyXlr8Objects.get(xlr8ObjLabel).objectFields.get(fieldWrap).listOfValues.size() > 0){
                                for(DataMoverOneValueWrapper valWrap : pageController.onlyXlr8Objects.get(xlr8ObjLabel).objectFields.get(fieldWrap).listOfValues){
                                    DataMoverValueInfoWrapper valInfoWrap = new DataMoverValueInfoWrapper();
                                    valInfoWrap.trgValue = valWrap.oneValue;
                                    fieldInfoWrap.matchingValues.add(valInfoWrap);
                                }
                            }
                            fieldInfoWrap.checkIfThereAreMoreThanOneCheckboxPicklist();
                            if(fieldInfoWrap.trgFieldRequired == true){
                                objInfoWrap.allMatchingFieldsRequired.put(fieldInfoWrap.trgFieldApiName,fieldInfoWrap);
                            }else{
                                objInfoWrap.allMatchingFieldsNotRequired.put(fieldInfoWrap.trgFieldApiName,fieldInfoWrap);
                            }
                        }
                    }
                }
            }           
        }
    }
     
    
    /*
     * Changes the information about the target object
     * in the current datamoverobjectinfowrapper
     */
    public void updateObjectWrapper(){
        pageController.currentObject.targetApiName = pageController.onlyXlr8Objects.get(pageController.currentObject.targetLabel).objApiName;
        pageController.currentObject.sourceExtIdField = DataMoverConstants.NOT_APPLICABLE_STRING;
        pageController.currentObject.targetExtIdField = DataMoverConstants.NOT_APPLICABLE_STRING;
        pageController.currentObject.allMatchingFieldsRequired.clear();
        pageController.currentObject.allMatchingFieldsNotRequired.clear();      
        populateXlr8Fields();
        DataMoverComponentsUtils.checkIfObjectExistsAndFill(pageController.currentObject);
        if(pageController.currentObject.allMatchingFieldsRequired.size() > 0){
            showRequired = true;
        }else{
            showRequired = false;
        }   
    }
    
    /*
     * Changes the object wrapper being handled 
     * at the moment for the one selected
     */
    public void changeCurrentObject(){
        String xlr8Label; 
        for(DataMoverObjectInfoWrapper objInfoWrap : pageController.srcTrgWrappers){
            if(objInfoWrap.sourceLabel == newCurrent){
                xlr8Label = objInfoWrap.targetLabel;
                pageController.currentObject = objInfoWrap;
            }
        }
        pageController.currentXlr8 = pageController.onlyXlr8Objects.get(xlr8Label);
        pageController.currentSource = pageController.onlySourceObjects.get(newCurrent);    
        if(pageController.currentObject.allMatchingFieldsRequired.size() > 0){
            showRequired = true;
        }else{
            showRequired = false;
        }
    }
    
    /* 
     * Takes the user to the fourth step
     * after preparing all the info to use there
     */
    public void goToStep4From3(){
        //split labels
        splitSrcLabelsToMatchRealLabel();
        //create external id field wrapper,
        //fill map, insert and continue
        fillFieldsWhenPicklistOrBoolean();
        pageController.finalMapping = updateFieldsWrapperWithSourceInfo();
        createFieldMappingForExternalIdField();
        pageController.goToStep4();
            
    }
    
    /*
     *Fills field hasMoreThanOneCheckboxPicklist on DataMoverFieldInfoWrapper
     *for fields that are boolean or picklist
     */
    public void fillFieldsWhenPicklistOrBoolean(){
        for(DataMoverObjectInfoWrapper objectInfoWrapper : pageController.srcTrgWrappers){
            for(DataMoverFieldInfoWrapper fieldInfoWrapper : objectInfoWrapper.allMatchingFieldsNotRequired.values()){  
                fieldInfoWrapper.checkIfThereAreMoreThanOneCheckboxPicklist();
            }
            for(DataMoverFieldInfoWrapper fieldInfoWrapper : objectInfoWrapper.allMatchingFieldsRequired.values()){ 
                fieldInfoWrapper.checkIfThereAreMoreThanOneCheckboxPicklist();
            }
        }       
    }
    /*
     * Searches and returns the current field
     * passed by the page
     * @return DataMoverFieldInfoWrapper: the current target field 
     */
    public DataMoverFieldInfoWrapper getTargetOneFieldWrapper(){
        for(String fieldWrap : pageController.currentObject.allMatchingFieldsRequired.keyset()){
            if(pageController.currentObject.allMatchingFieldsRequired.get(fieldWrap).trgFieldLbl == currentTrgFieldToShow){
                return pageController.currentObject.allMatchingFieldsRequired.get(fieldWrap);
            }
        }
        for(String fieldWrap : pageController.currentObject.allMatchingFieldsNotRequired.keyset()){
            if(pageController.currentObject.allMatchingFieldsNotRequired.get(fieldWrap).trgFieldLbl == currentTrgFieldToShow){
                return pageController.currentObject.allMatchingFieldsNotRequired.get(fieldWrap);
            }
        }
        return null;
    }
    
    /*
     * Returns a list of Select Options that has
     * the source field labels for the current object
     * @return List<SelectOption>: List of source field labels
     */
    public List<SelectOption> getSourceFieldLabelsForCurrent(){
        List<SelectOption> opt = new List<SelectOption>();
        String currentLabel = pageController.currentObject.sourceLabel;
        DataMoverOneObjectWrapper foundObj = pageController.onlySourceObjects.get(currentLabel);
        if(foundObj.objectFields != null && foundObj.objectFields.size() > 0){          
            for(String fieldWrap : foundObj.objectFields.keyset()){
                //as a value have label-type-apiname
                opt.add(new SelectOption(foundObj.objectFields.get(fieldWrap).fieldLabel + '-' + foundObj.objectFields.get(fieldWrap).fieldType + '-' +
                    foundObj.objectFields.get(fieldWrap).fieldApiName, foundObj.objectFields.get(fieldWrap).fieldLabel));
            }   
        }
        opt.sort();
        opt.add(0, new SelectOption(DataMoverConstants.NOT_APPLICABLE_STRING, DataMoverConstants.NOT_APPLICABLE_STRING)); 
        return opt;
     }
     
     /* 
      * Returns a list of Select Options that has
      * the target field labels for the current object
      * @return List<SelectOption>: List of target field labels
      */
     public List<SelectOption> getTargetFieldLabelsForCurrent(){
        List<SelectOption> options = new List<SelectOption>();
        String currentLabel = pageController.currentObject.targetLabel;
        DataMoverOneObjectWrapper foundObj = pageController.onlyXlr8Objects.get(currentLabel);
        if(foundObj.objectFields != null && foundObj.objectFields.size() > 0){          
            for(String fieldWrap : foundObj.objectFields.keyset()){
                options.add(new SelectOption(foundObj.objectFields.get(fieldWrap).fieldLabel + '-' + foundObj.objectFields.get(fieldWrap).fieldType + '-' +
                foundObj.objectFields.get(fieldWrap).fieldApiName, foundObj.objectFields.get(fieldWrap).fieldLabel));
            }
        }
        options.sort();
        options.add(0, new SelectOption(DataMoverConstants.NOT_APPLICABLE_STRING, DataMoverConstants.NOT_APPLICABLE_STRING)); 
        return options;
     }
     
     /*
     * Returns a list of Select Options that has
     * the source field labels for the current object, but without
     * boolean or picklist fields
     * @return List<SelectOption>: List of source field labels
     */
    public List<SelectOption> getSourceFieldLabelsForCurrentWithoutBooleansAndPicklists(){
        List<SelectOption> opt = new List<SelectOption>();
        String currentLabel = pageController.currentObject.sourceLabel;
        DataMoverOneObjectWrapper foundObj = pageController.onlySourceObjects.get(currentLabel);
        if(foundObj.objectFields != null && foundObj.objectFields.size() > 0){          
            for(DataMoverOneFieldWrapper fieldWrap : foundObj.objectFields.values()){
                if(fieldWrap.fieldType != DataMoverConstants.PICKLIST_STRING &&
                fieldWrap.fieldType != DataMoverConstants.BOOLEAN_STRING){
                    opt.add(new SelectOption(fieldWrap.fieldLabel + '-' + fieldWrap.fieldType + '-' + fieldWrap.fieldApiName, fieldWrap.fieldLabel));
                }
            }   
        }
        opt.sort();
        opt.add(0, new SelectOption(DataMoverConstants.NOT_APPLICABLE_STRING, DataMoverConstants.NOT_APPLICABLE_STRING)); 
        return opt;
     }
     
     /* 
      * Returns a list of Select Options that has
      * the target field labels for the current object, but without
      * boolean or picklist fields
      * @return List<SelectOption>: List of target field labels
      */
     public List<SelectOption> getTargetFieldLabelsForCurrentWithoutBooleansAndPicklists(){
        List<SelectOption> options = new List<SelectOption>();
        String currentLabel = pageController.currentObject.targetLabel;
        DataMoverOneObjectWrapper foundObj = pageController.onlyXlr8Objects.get(currentLabel);
        if(foundObj.objectFields != null && foundObj.objectFields.size() > 0){          
            for(DataMoverOneFieldWrapper fieldWrap : foundObj.objectFields.values()){
                if(fieldWrap.fieldType != DataMoverConstants.PICKLIST_STRING &&
                fieldWrap.fieldType != DataMoverConstants.BOOLEAN_STRING){
                    options.add(new SelectOption(fieldWrap.fieldLabel + '-' + fieldWrap.fieldType + '-' + fieldWrap.fieldApiName, fieldWrap.fieldLabel));
                }
            }
        }
        options.sort();
        if(options.size() > 0){
            options.add(0, new SelectOption(DataMoverConstants.NOT_APPLICABLE_STRING, DataMoverConstants.NOT_APPLICABLE_STRING)); 
        }else{
            options.add(new SelectOption(DataMoverConstants.NOT_APPLICABLE_STRING, DataMoverConstants.NOT_APPLICABLE_STRING)); 
        }
        return options;
     }
     
     
     /*
      * Iterates over listOfValues and gets the source value
      * to display on the page
      * @return List<SelectOption>: list of source values for the current field
      */
     public List<SelectOption> getSourceValuesForCurrentField(){
        List<SelectOption> options = new List<SelectOption>();
        for(DataMoverOneFieldWrapper fieldWrap : pageController.currentSource.objectFields.values()){
            if(fieldWrap.fieldLabel == currentSrcFieldToShow){
                system.debug('>>>>> ' + fieldWrap.listOfValues);
                if(fieldWrap.listOfValues.size() > 0){          
                    system.debug('>>>>>>> ' + fieldWrap.listOfValues);
                    for(DataMoverOneValueWrapper valueInfo : fieldWrap.listOfValues){
                        options.add(new SelectOption(valueInfo.oneValue, valueInfo.oneValue));
                    }
                }
            }
        }
        options.sort();
        system.debug('>>> ' + options.size() + ' - ' + DataMoverConstants.NOT_APPLICABLE_STRING);
        if(options.size() > 0){
            options.add(0, new SelectOption(DataMoverConstants.NOT_APPLICABLE_STRING, DataMoverConstants.NOT_APPLICABLE_STRING)); 
        }else{
            options.add(new SelectOption(DataMoverConstants.NOT_APPLICABLE_STRING, DataMoverConstants.NOT_APPLICABLE_STRING));
        }
        return options;
     }
      
     /*
      * The values assigned to srcFieldLbl have both the label
      * and the type of field, so they have to be split
      * and reassigned, along with the type
      */
      public void splitSrcLabelsToMatchRealLabel(){
          if(pageController.srcTrgWrappers != null){
              for(DataMoverObjectInfoWrapper dmInfoWrap : pageController.srcTrgWrappers){
                  //iterate over each map of fields to correct the labels and types
                  for(String fieldInfo : dmInfoWrap.allMatchingFieldsRequired.keySet()){
                      if(dmInfoWrap.allMatchingFieldsRequired.get(fieldInfo).srcFieldLbl != null && dmInfoWrap.allMatchingFieldsRequired.get(fieldInfo).srcFieldLbl != 'N/A'){
                          if(dmInfoWrap.allMatchingFieldsRequired.get(fieldInfo).srcFieldLbl.contains('-')){
                              String[] arrayLblType = dmInfoWrap.allMatchingFieldsRequired.get(fieldInfo).srcFieldLbl.split('-', 0);  
                              dmInfoWrap.allMatchingFieldsRequired.get(fieldInfo).srcFieldLbl = arrayLblType[0];
                              dmInfoWrap.allMatchingFieldsRequired.get(fieldInfo).srcFieldType = arrayLblType[1]; 
                              dmInfoWrap.allMatchingFieldsRequired.get(fieldInfo).srcFieldApiName = arrayLblType[2]; 
                          } 
                      }     
                  }
                  for(String fieldInfo : dmInfoWrap.allMatchingFieldsNotRequired.keySet()){
                      if(dmInfoWrap.allMatchingFieldsNotRequired.get(fieldInfo).srcFieldLbl != null && dmInfoWrap.allMatchingFieldsNotRequired.get(fieldInfo).srcFieldLbl != 'N/A'){
                          if(dmInfoWrap.allMatchingFieldsNotRequired.get(fieldInfo).srcFieldLbl.contains('-')){
                              String[] arrayLblType = dmInfoWrap.allMatchingFieldsNotRequired.get(fieldInfo).srcFieldLbl.split('-', 0);  
                              dmInfoWrap.allMatchingFieldsNotRequired.get(fieldInfo).srcFieldLbl = arrayLblType[0];
                              dmInfoWrap.allMatchingFieldsNotRequired.get(fieldInfo).srcFieldType = arrayLblType[1];  
                              dmInfoWrap.allMatchingFieldsNotRequired.get(fieldInfo).srcFieldApiName = arrayLblType[2];     
                          } 
                      }    
                  }
              }
          }          
      }
      
     
     /*
      * Updates the fields on srcTrgWrappers, and adds
      * the info about the source fields matched with 
      * the target fields. Creates a map with all the object info wrappers
      * and fills it with the objects. It also updates external id field wrapper.
      * @return Map<String, DataMoverObjectInfoWrapper>: map with object info wrappers
      */
     public Map<String, DataMoverObjectInfoWrapper> updateFieldsWrapperWithSourceInfo(){
        Map<String, DataMoverObjectInfoWrapper> returnMap = new Map<String, DataMoverObjectInfoWrapper>();
        if(pageController.srcTrgWrappers != null){  
            //iterate over the list of srcTrgWrappers
            for(Integer objNum = 0; objNum < pageController.srcTrgWrappers.size(); objNum++){
                //first set the information about the external id fields for both objects
                if(pageController.srcTrgWrappers[objNum].sourceExtIdField != null && !pageController.srcTrgWrappers[objNum].sourceExtIdField.contains(DataMoverConstants.NOT_APPLICABLE_STRING)){
                    String[] srcExtIdLabelType;
                    String[] trgExtIdLabelType;
                    if(pageController.srcTrgWrappers[objNum].sourceExtIdField.contains('-')){
                        srcExtIdLabelType = pageController.srcTrgWrappers[objNum].sourceExtIdField.split('-', 0);
                    }
                    if(pageController.srcTrgWrappers[objNum].sourceExtIdField.contains('-')){
                        trgExtIdLabelType = pageController.srcTrgWrappers[objNum].targetExtIdField.split('-', 0);
                    }
                    system.debug('>>> ' + pageController.onlySourceObjects);
                    system.debug('>>>> ' + srcExtIdLabelType[2]);
                    pageController.srcTrgWrappers[objNum].sourceExtIdFieldAPI = pageController.onlySourceObjects.get(pageController.srcTrgWrappers[objNum].sourceLabel).objectFields.get(srcExtIdLabelType[2]).fieldApiName;
                    pageController.srcTrgWrappers[objNum].targetExtIdFieldAPI = pageController.onlyXlr8Objects.get(pageController.srcTrgWrappers[objNum].targetLabel).objectFields.get(trgExtIdLabelType[2]).fieldApiName;              
                    pageController.srcTrgWrappers[objNum].sourceExtIdFieldType = pageController.onlySourceObjects.get(pageController.srcTrgWrappers[objNum].sourceLabel).objectFields.get(srcExtIdLabelType[2]).fieldType;              
                    pageController.srcTrgWrappers[objNum].targetExtIdFieldType = pageController.onlyXlr8Objects.get(pageController.srcTrgWrappers[objNum].targetLabel).objectFields.get(trgExtIdLabelType[2]).fieldType;                
                    pageController.srcTrgWrappers[objNum].sourceExtIdField = srcExtIdLabelType[0];              
                    pageController.srcTrgWrappers[objNum].targetExtIdField = trgExtIdLabelType[0];              
                    pageController.srcTrgWrappers[objNum].sourceExtIdFieldIsNameField = pageController.onlySourceObjects.get(pageController.srcTrgWrappers[objNum].sourceLabel).objectFields.get(srcExtIdLabelType[2]).isNameField;                         
                    pageController.srcTrgWrappers[objNum].targetExtIdFieldIsNameField = pageController.onlyXlr8Objects.get(pageController.srcTrgWrappers[objNum].targetLabel).objectFields.get(trgExtIdLabelType[2]).isNameField;
                }else{ //else put 'N/A' on those fields
                    pageController.srcTrgWrappers[objNum].sourceExtIdFieldAPI = DataMoverConstants.NOT_APPLICABLE_STRING;
                    pageController.srcTrgWrappers[objNum].targetExtIdFieldAPI = DataMoverConstants.NOT_APPLICABLE_STRING;
                    pageController.srcTrgWrappers[objNum].sourceExtIdFieldType = DataMoverConstants.NOT_APPLICABLE_STRING;
                    pageController.srcTrgWrappers[objNum].targetExtIdFieldType = DataMoverConstants.NOT_APPLICABLE_STRING;
                    pageController.srcTrgWrappers[objNum].sourceExtIdFieldIsNameField = false;                              
                    pageController.srcTrgWrappers[objNum].targetExtIdFieldIsNameField = false;
                    pageController.srcTrgWrappers[objNum].sourceExtIdField = DataMoverConstants.NOT_APPLICABLE_STRING;
                    pageController.srcTrgWrappers[objNum].targetExtIdField = DataMoverConstants.NOT_APPLICABLE_STRING;
                }
                //iterate over its fields
                for(String fieldInfo : pageController.srcTrgWrappers[objNum].allMatchingFieldsRequired.keySet()){
                    DataMoverFieldInfoWrapper fieldInfoObj = pageController.srcTrgWrappers[objNum].allMatchingFieldsRequired.get(fieldInfo);
                    if(fieldInfoObj.srcFieldLbl != null && fieldInfoObj.srcFieldLbl != DataMoverConstants.NOT_APPLICABLE_STRING){
                        
                        DataMoverOneFieldWrapper oneField = pageController.onlySourceObjects.get(pageController.srcTrgWrappers[objNum].sourceLabel).objectFields.get(fieldInfoObj.srcFieldApiName);
                        fieldInfoObj.srcFieldApiName = oneField.fieldApiName;
                        fieldInfoObj.srcFieldType = oneField.fieldType;
                        fieldInfoObj.srcFieldRequired = oneField.isFieldRequired;
                        fieldInfoObj.srcObjApi = oneField.objectApiName;
                        fieldInfoObj.srcIsNameField = oneField.isNameField;
                    }
                    else{
                        pageController.srcTrgWrappers[objNum].allMatchingFieldsRequired.remove(fieldInfo);
                    }
                }
                for(String fieldInfo : pageController.srcTrgWrappers[objNum].allMatchingFieldsNotRequired.keySet()){
                    DataMoverFieldInfoWrapper fieldInfoObj = pageController.srcTrgWrappers[objNum].allMatchingFieldsNotRequired.get(fieldInfo);
                    if(fieldInfoObj.srcFieldLbl != null && fieldInfoObj.srcFieldLbl != DataMoverConstants.NOT_APPLICABLE_STRING){                       
                        DataMoverOneFieldWrapper oneField = pageController.onlySourceObjects.get(pageController.srcTrgWrappers[objNum].sourceLabel).objectFields.get(fieldInfoObj.srcFieldApiName);
                        fieldInfoObj.srcFieldApiName = oneField.fieldApiName;
                        fieldInfoObj.srcFieldType = oneField.fieldType;
                        fieldInfoObj.srcFieldRequired = oneField.isFieldRequired;
                        fieldInfoObj.srcObjApi = oneField.objectApiName;
                        fieldInfoObj.srcIsNameField = oneField.isNameField;
                    }else{
                        pageController.srcTrgWrappers[objNum].allMatchingFieldsNotRequired.remove(fieldInfo);
                    }
                }
                
                //put the object in the map
                returnMap.put(pageController.srcTrgWrappers[objNum].sourceApiName +
                    pageController.srcTrgWrappers[objNum].targetApiName, pageController.srcTrgWrappers[objNum]);
            }
        }
        return returnMap;
     }
     
     /*
      * Iterates over each DataMoverObjectInfoWrapper in srcTrgWrappers, and creates
      * another DataMoverFieldInfoWrapper for the selected external id field 
      */
     public void createFieldMappingForExternalIdField(){
        
        //check if wrapper for external id field exists     
        system.debug('>>>>> : ' + pageController.srcTrgWrappers);
        for(DataMoverObjectInfoWrapper objectInfoWrapper : pageController.srcTrgWrappers){
            //if there was already a field mapping for ext id, remove it from maps
            if(objectInfoWrapper.externalIdFieldMapping.srcFieldApiName != null){
                if(objectInfoWrapper.externalIdFieldMapping.srcFieldApiName.equalsIgnoreCase(objectInfoWrapper.sourceExtIdFieldAPI)){
                    DataMoverComponentsUtils.deleteExternalIdFieldMapping(objectInfoWrapper.externalIdFieldMapping.srcFieldApiName, objectInfoWrapper.externalIdFieldMapping.trgFieldApiName);
                    objectInfoWrapper.externalIdFieldMapping.fieldMappingId = null;
                }       
            }
            
            //then create the new one
            if(!objectInfoWrapper.sourceExtIdField.equalsIgnoreCase(DataMoverConstants.NOT_APPLICABLE_STRING)){
                //check if it already exists, if not create it
                if(objectInfoWrapper.externalIdFieldMapping.srcFieldLbl != null && 
                objectInfoWrapper.externalIdFieldMapping.srcFieldLbl.contains('-')){                    
                    //split source field of externalIdFieldMapping
                    String[] arrayFields = objectInfoWrapper.externalIdFieldMapping.srcFieldLbl.split('-');
                    objectInfoWrapper.externalIdFieldMapping.srcFieldLbl = arrayFields[0];
                    if(objectInfoWrapper.externalIdFieldMapping.srcFieldLbl != objectInfoWrapper.sourceExtIdField){ 
                        DataMoverFieldInfoWrapper fieldWrapper = new DataMoverFieldInfoWrapper();
                        fieldWrapper.srcFieldLbl = pageController.onlySourceObjects.get(objectInfoWrapper.sourceLabel).objectFields.get(objectInfoWrapper.sourceExtIdFieldAPI).fieldLabel;
                        fieldWrapper.srcFieldApiName = pageController.onlySourceObjects.get(objectInfoWrapper.sourceLabel).objectFields.get(objectInfoWrapper.sourceExtIdFieldAPI).fieldApiName;
                        fieldWrapper.srcFieldType = pageController.onlySourceObjects.get(objectInfoWrapper.sourceLabel).objectFields.get(objectInfoWrapper.sourceExtIdFieldAPI).fieldType;
                        fieldWrapper.srcFieldRequired = pageController.onlySourceObjects.get(objectInfoWrapper.sourceLabel).objectFields.get(objectInfoWrapper.sourceExtIdFieldAPI).isFieldRequired;
                        fieldWrapper.srcIsNameField = pageController.onlySourceObjects.get(objectInfoWrapper.sourceLabel).objectFields.get(objectInfoWrapper.sourceExtIdFieldAPI).isNameField;
                        fieldWrapper.srcObjApi = pageController.onlySourceObjects.get(objectInfoWrapper.sourceLabel).objectFields.get(objectInfoWrapper.sourceExtIdFieldAPI).objectApiName;
                        fieldWrapper.trgFieldLbl = pageController.onlyXlr8Objects.get(objectInfoWrapper.targetLabel).objectFields.get(objectInfoWrapper.targetExtIdFieldAPI).fieldLabel;
                        fieldWrapper.trgFieldApiName = pageController.onlyXlr8Objects.get(objectInfoWrapper.targetLabel).objectFields.get(objectInfoWrapper.targetExtIdFieldAPI).fieldApiName;
                        fieldWrapper.trgFieldType = pageController.onlyXlr8Objects.get(objectInfoWrapper.targetLabel).objectFields.get(objectInfoWrapper.targetExtIdFieldAPI).fieldType;
                        fieldWrapper.trgFieldRequired = pageController.onlyXlr8Objects.get(objectInfoWrapper.targetLabel).objectFields.get(objectInfoWrapper.targetExtIdFieldAPI).isFieldRequired;
                        fieldWrapper.trgIsNameField = pageController.onlyXlr8Objects.get(objectInfoWrapper.targetLabel).objectFields.get(objectInfoWrapper.targetExtIdFieldAPI).isNameField;
                        fieldWrapper.trgObjApi = pageController.onlyXlr8Objects.get(objectInfoWrapper.targetLabel).objectFields.get(objectInfoWrapper.targetExtIdFieldAPI).objectApiName;
                        fieldWrapper.checkIfThereAreMoreThanOneCheckboxPicklist();
                        objectInfoWrapper.externalIdFieldMapping = fieldWrapper;
                    }
                }else{
                    DataMoverFieldInfoWrapper fieldWrapper = new DataMoverFieldInfoWrapper();
                    fieldWrapper.srcFieldLbl = pageController.onlySourceObjects.get(objectInfoWrapper.sourceLabel).objectFields.get(objectInfoWrapper.sourceExtIdFieldAPI).fieldLabel;
                    fieldWrapper.srcFieldApiName = pageController.onlySourceObjects.get(objectInfoWrapper.sourceLabel).objectFields.get(objectInfoWrapper.sourceExtIdFieldAPI).fieldApiName;
                    fieldWrapper.srcFieldType = pageController.onlySourceObjects.get(objectInfoWrapper.sourceLabel).objectFields.get(objectInfoWrapper.sourceExtIdFieldAPI).fieldType;
                    fieldWrapper.srcFieldRequired = pageController.onlySourceObjects.get(objectInfoWrapper.sourceLabel).objectFields.get(objectInfoWrapper.sourceExtIdFieldAPI).isFieldRequired;
                    fieldWrapper.srcIsNameField = pageController.onlySourceObjects.get(objectInfoWrapper.sourceLabel).objectFields.get(objectInfoWrapper.sourceExtIdFieldAPI).isNameField;
                    fieldWrapper.srcObjApi = pageController.onlySourceObjects.get(objectInfoWrapper.sourceLabel).objectFields.get(objectInfoWrapper.sourceExtIdFieldAPI).objectApiName;
                    fieldWrapper.trgFieldLbl = pageController.onlyXlr8Objects.get(objectInfoWrapper.targetLabel).objectFields.get(objectInfoWrapper.targetExtIdFieldAPI).fieldLabel;
                    fieldWrapper.trgFieldApiName = pageController.onlyXlr8Objects.get(objectInfoWrapper.targetLabel).objectFields.get(objectInfoWrapper.targetExtIdFieldAPI).fieldApiName;
                    fieldWrapper.trgFieldType = pageController.onlyXlr8Objects.get(objectInfoWrapper.targetLabel).objectFields.get(objectInfoWrapper.targetExtIdFieldAPI).fieldType;
                    fieldWrapper.trgFieldRequired = pageController.onlyXlr8Objects.get(objectInfoWrapper.targetLabel).objectFields.get(objectInfoWrapper.targetExtIdFieldAPI).isFieldRequired;
                    fieldWrapper.trgIsNameField = pageController.onlyXlr8Objects.get(objectInfoWrapper.targetLabel).objectFields.get(objectInfoWrapper.targetExtIdFieldAPI).isNameField;
                    fieldWrapper.trgObjApi = pageController.onlyXlr8Objects.get(objectInfoWrapper.targetLabel).objectFields.get(objectInfoWrapper.targetExtIdFieldAPI).objectApiName;
                    fieldWrapper.checkIfThereAreMoreThanOneCheckboxPicklist();
                    objectInfoWrapper.externalIdFieldMapping = fieldWrapper;
                }
            }    
        }
     }
    
     /*
      *
      *
      */
     public void popUps(){
        //System.debug('####currentSrcFieldToShow ' + currentSrcFieldToShow);
        //System.debug('****currentTrgFieldToShow ' + currentTrgFieldToShow);
     }
    
    
    /*
     * Checks that all the required fields and the external
     * ids have been completed by the user
     */
    public void checkThatRequiredFieldsAndExtIdAreCompleted(){
        externalIdsNotFilled = false;
        requiredFieldsNotFilled = false;
        differentReferences = false;
        if(pageController.srcTrgWrappers != null){
            for(DataMoverObjectInfoWrapper finObj : pageController.srcTrgWrappers){         
                //check if ext ids are completed unless it is mapping Securities
                if(!finObj.targetApiName.toLowercase().contains('securities')){
                    if(finObj.sourceExtIdField == DataMoverConstants.NOT_APPLICABLE_STRING || finObj.targetExtIdField == DataMoverConstants.NOT_APPLICABLE_STRING ||
                    finObj.sourceExtIdField == null || finObj.targetExtIdField == null){
                        externalIdsNotFilled = true;
                    }
                }
                //check if required fields are completed
                if(finObj.allMatchingFieldsRequired.size() > 0){
                    for(DataMoverFieldInfoWrapper finField : finObj.allMatchingFieldsRequired.values()){
                        if((finField.srcFieldLbl == DataMoverConstants.NOT_APPLICABLE_STRING ||
                        finField.srcFieldLbl == null)){
                            //if external id is null or N/A, the req field is not the ext id, so requiredFieldsNotFilled = true
                            if(finObj.targetExtIdField == null ||
                            finObj.targetExtIdField.equalsIgnoreCase(DataMoverConstants.NOT_APPLICABLE_STRING)){
                                requiredFieldsNotFilled = true;
                            }else{
                                //if ext id is not N/A and that req field was not used as ext id, also true
                                String[] lblTypeArray = finObj.targetExtIdField.split('-', 0);
                                if(finField.trgFieldLbl != lblTypeArray[0]){
                                    requiredFieldsNotFilled = true;
                                }
                            }
                        }
                    }
                }
                //get the field maps of target and source objects
                Map<String, Schema.SObjectField> trgMap = pageController.globalDescribe.get(finObj.targetApiName.toLowerCase()).getDescribe().fields.getMap();
                Map<String, Schema.SObjectField> srcMap = pageController.globalDescribe.get(finObj.sourceApiName.toLowerCase()).getDescribe().fields.getMap();
                //for each required or non required field in those objects
                if(finObj.allMatchingFieldsRequired.size() > 0){
                    for(DataMoverFieldInfoWrapper finField : finObj.allMatchingFieldsRequired.values()){ 
                        if(finField.srcFieldLbl != null && finField.srcFieldLbl != DataMoverConstants.NOT_APPLICABLE_STRING){
                            String[] srcArray = finField.srcFieldLbl.split('-');
                            //check if their type is reference
                            if(srcArray[1].equalsIgnoreCase(DataMoverConstants.REFERENCE_STRING) && finField.trgFieldType.equalsIgnoreCase(DataMoverConstants.REFERENCE_STRING)){
                                //check if they refer to another object
                                String trgFieldApi = finField.trgFieldApiName; 
                                String srcFieldApi = srcArray[2];
                                if(!trgMap.get(trgFieldApi.toLowerCase()).getDescribe().getReferenceTo().equals(srcMap.get(srcFieldApi.toLowerCase()).getDescribe().getReferenceTo())){
                                    differentReferences = true;
                                }
                            }
                        }
                    }
                }
                if(finObj.allMatchingFieldsNotRequired.size() > 0){
                    for(DataMoverFieldInfoWrapper finField : finObj.allMatchingFieldsNotRequired.values()){
                        if(finField.srcFieldLbl != null && finField.srcFieldLbl != DataMoverConstants.NOT_APPLICABLE_STRING){
                        
                            String[] srcArray = finField.srcFieldLbl.split('-');
                            //check if their type is reference
                            if(srcArray[1].equalsIgnoreCase(DataMoverConstants.REFERENCE_STRING) && finField.trgFieldType.equalsIgnoreCase(DataMoverConstants.REFERENCE_STRING)){
                                //check if they refer to another object
                                String trgFieldApi = finField.trgFieldApiName; 
                                String srcFieldApi = srcArray[2];
                                if(!trgMap.get(trgFieldApi.toLowerCase()).getDescribe().getReferenceTo().equals(srcMap.get(srcFieldApi.toLowerCase()).getDescribe().getReferenceTo())){
                                    differentReferences = true;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /*
     * If there is any field that is a picklist or checkbox, 
     * it checks that its values have been selected, if they have
     * it returns true, else false
     * @return Boolean: true if all values were mapped, false if not
     */
    public Boolean checkThatAllValuesWereMapped(){
        //iterate over srcTrgWrappers
        if(pageController.srcTrgWrappers != null){
            for(DataMoverObjectInfoWrapper objectWrapper : pageController.srcTrgWrappers){  
                //iterate over allMatchingFieldsRequired
                if(objectWrapper.allMatchingFieldsRequired.size() > 0){
                    for(DataMoverFieldInfoWrapper fieldWrapper : objectWrapper.allMatchingFieldsRequired.values()){
                        if(fieldWrapper.srcFieldLbl != DataMoverConstants.NOT_APPLICABLE_STRING){
                            if((fieldWrapper.srcFieldType == DataMoverConstants.BOOLEAN_STRING && fieldWrapper.trgFieldType == DataMoverConstants.PICKLIST_STRING) ||
                            (fieldWrapper.srcFieldType == DataMoverConstants.BOOLEAN_STRING && fieldWrapper.trgFieldType == DataMoverConstants.BOOLEAN_STRING) ||
                            (fieldWrapper.srcFieldType == DataMoverConstants.PICKLIST_STRING && fieldWrapper.trgFieldType == DataMoverConstants.PICKLIST_STRING) ||
                            (fieldWrapper.srcFieldType == DataMoverConstants.PICKLIST_STRING && fieldWrapper.trgFieldType == DataMoverConstants.BOOLEAN_STRING)){
                                if(fieldWrapper.matchingValues.size() == 0){
                                    return false;
                                }else{
                                    for(DataMoverValueInfoWrapper valueWrapper : fieldWrapper.matchingValues){
                                        if(valueWrapper.srcValue == null || valueWrapper.trgValue == null){
                                            return false;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                //iterate over allMatchingFieldsNotRequired
                if(objectWrapper.allMatchingFieldsRequired.size() > 0){
                    for(DataMoverFieldInfoWrapper fieldWrapper : objectWrapper.allMatchingFieldsNotRequired.values()){
                        if(fieldWrapper.srcFieldLbl != DataMoverConstants.NOT_APPLICABLE_STRING){
                            if((fieldWrapper.srcFieldType == DataMoverConstants.BOOLEAN_STRING && fieldWrapper.trgFieldType == DataMoverConstants.PICKLIST_STRING) ||
                            (fieldWrapper.srcFieldType == DataMoverConstants.BOOLEAN_STRING && fieldWrapper.trgFieldType == DataMoverConstants.BOOLEAN_STRING) ||
                            (fieldWrapper.srcFieldType == DataMoverConstants.PICKLIST_STRING && fieldWrapper.trgFieldType == DataMoverConstants.PICKLIST_STRING) ||
                            (fieldWrapper.srcFieldType == DataMoverConstants.PICKLIST_STRING && fieldWrapper.trgFieldType == DataMoverConstants.BOOLEAN_STRING)){
                                if(fieldWrapper.matchingValues.size() == 0){
                                    return false;
                                }else{
                                    for(DataMoverValueInfoWrapper valueWrapper : fieldWrapper.matchingValues){
                                        if(valueWrapper.srcValue == null || valueWrapper.srcValue == DataMoverConstants.NOT_APPLICABLE_STRING || 
                                        valueWrapper.trgValue == null || valueWrapper.trgValue == DataMoverConstants.NOT_APPLICABLE_STRING){
                                            return false;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return true;
    }
    
    
    /*
     * It reconstructs srcTrgWrappers with the info that it
     * had, along with the values that were already selected. 
     * To these, a dash and srcFieldType is added to srcFieldLbl
     * so the select lists display the prev selection.
     * It is called when the user goes back from 4 to 3.
     */
     public void reconstructSrcTrgWrappers(){
        //iterate over srcTrgWrappers
        for(DataMoverObjectInfoWrapper objectInfoWrapper : pageController.srcTrgWrappers){
            //reconstruct id labels with the type to be displayed on step 3
            objectInfoWrapper.sourceExtIdField = objectInfoWrapper.sourceExtIdField + '-' + objectInfoWrapper.sourceExtIdFieldType + '-' + objectInfoWrapper.sourceExtIdFieldAPI;
            objectInfoWrapper.targetExtIdField = objectInfoWrapper.targetExtIdField + '-' + objectInfoWrapper.targetExtIdFieldType + '-' + objectInfoWrapper.targetExtIdFieldAPI;
            //iterate over onlyXlr8Objects
            for(DataMoverOneObjectWrapper oneObjectWrapper : pageController.onlyXlr8Objects.values()){          
                //if the object is the same, reconstruct its fields
                if(oneObjectWrapper.objLabel == objectInfoWrapper.targetLabel){
                    //iterate over the fields of the object in onlyXlr8Objects
                    for(DataMoverOneFieldWrapper oneFieldWrapper : oneObjectWrapper.objectFields.values()){
                        Boolean fieldExistsAlready = false;
                        //iterate over the fields of the object in srcTrgWrappers (first allMatchingFieldsRequired)
                        for(DataMoverFieldInfoWrapper fieldInfoWrapper : objectInfoWrapper.allMatchingFieldsRequired.values()){
                            //if the target label is the same, only modify the srcFieldLbl and set fieldExistsAlready to true
                            if(fieldInfoWrapper.trgFieldLbl != null && 
                            oneFieldWrapper.fieldLabel.equalsIgnoreCase(fieldInfoWrapper.trgFieldLbl)){
                                fieldExistsAlready = true;
                                fieldInfoWrapper.srcFieldLbl += '-' + fieldInfoWrapper.srcFieldType + '-' + fieldInfoWrapper.srcFieldApiName;
                            }
                        }
                        //iterate over the fields of the object in srcTrgWrappers (then allMatchingFieldsNotRequired)
                        for(DataMoverFieldInfoWrapper fieldInfoWrapper : objectInfoWrapper.allMatchingFieldsNotRequired.values()){
                            //if the target label is the same, only modify the srcFieldLbl and set fieldExistsAlready to true
                            if(fieldInfoWrapper.trgFieldLbl != null &&
                            oneFieldWrapper.fieldLabel.equalsIgnoreCase(fieldInfoWrapper.trgFieldLbl)){
                                fieldExistsAlready = true;
                                fieldInfoWrapper.srcFieldLbl += '-' + fieldInfoWrapper.srcFieldType + '-' + fieldInfoWrapper.srcFieldApiName;
                            }
                        }
                        //if field does not exist, create the field, and add only target info
                        if(!fieldExistsAlready){
                            DataMoverFieldInfoWrapper fieldInfoWrap = new DataMoverFieldInfoWrapper();
                            fieldInfoWrap.trgFieldLbl = oneFieldWrapper.fieldLabel;
                            fieldInfoWrap.trgFieldApiName = oneFieldWrapper.fieldApiName;
                            fieldInfoWrap.trgFieldType = oneFieldWrapper.fieldType;
                            fieldInfoWrap.trgFieldRequired = oneFieldWrapper.isFieldRequired;
                            fieldInfoWrap.trgObjApi = oneObjectWrapper.objApiName;
                            fieldInfoWrap.trgIsNameField = oneFieldWrapper.isNameField;
                            //add the xlr8 values if there are picklists or checkboxes
                            if(oneFieldWrapper.listOfValues != null && oneFieldWrapper.listOfValues.size() > 0){
                                for(DataMoverOneValueWrapper oneValueWrapper : oneFieldWrapper.listOfValues){
                                    DataMoverValueInfoWrapper valInfoWrap = new DataMoverValueInfoWrapper();
                                    valInfoWrap.trgValue = oneValueWrapper.oneValue;
                                    fieldInfoWrap.matchingValues.add(valInfoWrap);
                                }
                            }
                            fieldInfoWrap.checkIfThereAreMoreThanOneCheckboxPicklist();
                            if(fieldInfoWrap.trgFieldRequired){
                                objectInfoWrapper.allMatchingFieldsRequired.put(fieldInfoWrap.trgFieldApiName, fieldInfoWrap);
                            }else{
                                objectInfoWrapper.allMatchingFieldsNotRequired.put(fieldInfoWrap.trgFieldApiName, fieldInfoWrap);
                            }
                        }
                    }
                }
            }
        }
        system.debug('>>>>>>>>>>> ' + pageController.srcTrgWrappers);
     }
    
    /*
     * It takes the user back to step 2,
     * and takes back all the methods
     * executed in step 2 and in the 
     * instantiation of component 3
     */
    public void goBackToStep2(){
        pageController.initStep3Component = true;
        pageController.initStep2Component = true;
        externalIdsNotFilled = false;
        requiredFieldsNotFilled = false;
        pageController.currentXlr8 = null;
        pageController.currentSource = null;
        pageController.onlyXlr8Objects = null;
        pageController.onlySourceObjects = null;
        pageController.srcTrgWrappers = null;
        pageController.goToStep2();
    }
    
}