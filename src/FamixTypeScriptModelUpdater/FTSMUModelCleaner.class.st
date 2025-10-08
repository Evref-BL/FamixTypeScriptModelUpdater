Class {
	#name : 'FTSMUModelCleaner',
	#superclass : 'Object',
	#traits : 'FamixTypeScriptTVisitor',
	#classTraits : 'FamixTypeScriptTVisitor classTrait',
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

{ #category : 'visiting' }
FTSMUModelCleaner >> visitEntity: aFamixTypeScriptEntity [
	^ nil
]

{ #category : 'visiting' }
FTSMUModelCleaner >> visitFamixTClass: aFamixTypeScriptClass [

	aFamixTypeScriptClass methods copy do: [ :m | 
		m parentType: nil.
		m accept: self ].
	"aFamixTypeScriptClass attributes copy do: [ :att | 
		att parentType: nil.
		att accept: self ]."
	aFamixTypeScriptClass mooseModel ifNotNil: [ 
		aFamixTypeScriptClass mooseModel remove: aFamixTypeScriptClass ]
]

{ #category : 'visiting' }
FTSMUModelCleaner >> visitFamixTypeScriptLocalVariable: aFamixTypeScriptLocalVariable [

	aFamixTypeScriptLocalVariable mooseModel ifNotNil: [ aFamixTypeScriptLocalVariable mooseModel remove: aFamixTypeScriptLocalVariable ]
]

{ #category : 'visiting' }
FTSMUModelCleaner >> visitFamixTypeScriptMethod: aFamixTypeScriptMethod [
	aFamixTypeScriptMethod localVariables copy do: [ :att | 
		att parentBehaviouralEntity: nil.
		att accept: self ].
	aFamixTypeScriptMethod mooseModel ifNotNil: [ aFamixTypeScriptMethod mooseModel remove: aFamixTypeScriptMethod ]
]
