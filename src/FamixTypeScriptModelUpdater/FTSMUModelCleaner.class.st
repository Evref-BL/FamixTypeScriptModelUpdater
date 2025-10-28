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

{ #category : 'as yet unclassified' }
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
FTSMUModelCleaner >> visitFamixTypeScriptClass: aFamixTypeScriptClass [

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
FTSMUModelCleaner >> visitFamixTypeScriptEnum: aFamixTypeScriptEnum [

	aFamixTypeScriptEnum mooseModel ifNotNil: [
		aFamixTypeScriptEnum mooseModel remove: aFamixTypeScriptEnum ]
]

{ #category : 'visiting' }
FTSMUModelCleaner >> visitFamixTypeScriptFunction: aFamixTypeScriptFunction [

	aFamixTypeScriptFunction mooseModel ifNotNil: [
		aFamixTypeScriptFunction mooseModel remove:
			aFamixTypeScriptFunction ]
]

{ #category : 'visiting' }
FTSMUModelCleaner >> visitFamixTypeScriptInterface: aFamixTypeScriptInterface [

	aFamixTypeScriptInterface mooseModel ifNotNil: [
		aFamixTypeScriptInterface mooseModel remove:
			aFamixTypeScriptInterface ]
]

{ #category : 'visiting' }
FTSMUModelCleaner >> visitFamixTypeScriptLocalVariable: aFamixTypeScriptLocalVariable [

	aFamixTypeScriptLocalVariable mooseModel ifNotNil: [
		aFamixTypeScriptLocalVariable mooseModel remove:
			aFamixTypeScriptLocalVariable ]
]

{ #category : 'visiting' }
FTSMUModelCleaner >> visitFamixTypeScriptMethod: aFamixTypeScriptMethod [

	aFamixTypeScriptMethod localVariables copy do: [ :att |
		att parentBehaviouralEntity: nil.
		att accept: self ].
	aFamixTypeScriptMethod mooseModel ifNotNil: [
		aFamixTypeScriptMethod mooseModel remove: aFamixTypeScriptMethod ]
]
