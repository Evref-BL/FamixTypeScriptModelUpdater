Class {
	#name : 'FTSMUModelCleaner',
	#superclass : 'Object',
	#instVars : [
		'famixEntity'
	],
	#category : 'FamixTypeScriptModelUpdater-Cleaner',
	#package : 'FamixTypeScriptModelUpdater',
	#tag : 'Cleaner'
}

{ #category : 'api' }
FTSMUModelCleaner >> clean: aFamixEntity [

	aFamixEntity ifNotNil: [ 
		famixEntity := aFamixEntity.
		aFamixEntity accept: self ]
]
