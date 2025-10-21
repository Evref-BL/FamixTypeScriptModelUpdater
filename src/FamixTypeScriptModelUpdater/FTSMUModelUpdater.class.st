Class {
	#name : 'FTSMUModelUpdater',
	#superclass : 'FASTTypeScriptVisitor',
	#traits : 'TFTSMUEntityFactory',
	#classTraits : 'TFTSMUEntityFactory classTrait',
	#instVars : [
		'famixEntity',
		'cleaner'
	],
	#category : 'FamixTypeScriptModelUpdater-Updater',
	#package : 'FamixTypeScriptModelUpdater',
	#tag : 'Updater'
}

{ #category : 'adding' }
FTSMUModelUpdater >> addModifier: modifier to: famixMethod [
	(modifier = #private) ifTrue: [ 
		^ famixMethod isPrivate: true ].
	(modifier = #synchronized) ifTrue: [ 
		^ famixMethod isSynchronized: true ]
]

{ #category : 'accessing' }
FTSMUModelUpdater >> cleaner [

	^ cleaner
]

{ #category : 'accessing' }
FTSMUModelUpdater >> cleaner: anObject [

	cleaner := anObject
]

{ #category : 'accessing' }
FTSMUModelUpdater >> famixEntity [

	^ famixEntity
]

{ #category : 'accessing' }
FTSMUModelUpdater >> famixEntity: anObject [

	famixEntity := anObject
]

{ #category : 'initialization' }
FTSMUModelUpdater >> initialize [ 
	cleaner := FTSMUModelCleaner new.
]

{ #category : 'as yet unclassified' }
FTSMUModelUpdater >> resolveTypeNameOf: aType [

	"aType ifNil: [ ^ nil ].
	(aType isKindOf: FASTJavaTypeName) ifTrue: [ ^ aType name ].
	(aType isKindOf: FASTJavaPrimitiveTypeExpression) ifTrue: [ self h ].
	(aType isKindOf: FASTJavaArrayTypeExpression) ifTrue: [ 
		^ self resolveTypeNameOf: aType baseType ].
	^ self resolveTypeNameOf: aType typeName"
]

{ #category : 'model - create' }
FTSMUModelUpdater >> retrieveClassFromModel: aClassName [ 
	"^ (fastModel allWithType: FASTTypeScriptImportClause) ""Pay Attention""
		  detect: [ :importDeclaration |
			  importDeclaration qualifiedName name = aClassName ]
		  ifFound: [ :importDeclaration |
			  self famixModel allPackages
				  detect: [ :pa |
					  pa qualifiedName
					  = importDeclaration qualifiedName namespace fullName ]
				  ifFound: [ :package |
					  package types
						  detect: [ :type | type name = aClassName ]
						  ifNone: [ nil ] ]
				  ifNone: [ nil ] ]
		  ifNone: [
			  self famixModel allModelTypes asOrderedCollection
				  detect: [ :class | class name = aClassName ]
				  ifNone: [ nil ] ]"
]

{ #category : 'updating' }
FTSMUModelUpdater >> update [

	| declarations entities |
	declarations := self fastModel allWithSubTypesOfAny: {
			                FASTTypeScriptClassDeclaration.
			                FASTTypeScriptInterfaceDeclaration.
			                FASTTypeScriptEnumDeclaration.
			                FASTTypeScriptFunctionDeclaration }.


	entities := declarations collect: [ :each |
		            | newlyCreatedEntity |
		            newlyCreatedEntity := each accept: self.
		            self updateAssociationFor: newlyCreatedEntity ].
	self cleaner clean: famixEntity.

	^ entities
]

{ #category : 'as yet unclassified' }
FTSMUModelUpdater >> updateAssociationFor: newlyCreatedEntity [

	FTSMUModelAssociationUpdater new
		famixModel: newlyCreatedEntity mooseModel;
		fastModel: self fastModel;
		famixEntity: famixEntity;
		fileAnchorPath: self fileAnchorPath;
		newFamixEntity: newlyCreatedEntity;
		update
]

{ #category : 'visiting' }
FTSMUModelUpdater >> visitFASTTypeScriptClassDeclaration: aFastTypeScriptClassDeclaration [

	| famixClass |
	famixClass := self
		              create: FamixTypeScriptClass
		              from: aFastTypeScriptClassDeclaration.
	famixClass name: aFastTypeScriptClassDeclaration name sourceCode.
	famixClass fast: aFastTypeScriptClassDeclaration.

	(aFastTypeScriptClassDeclaration body genericChildren select: [
		 :child | child isKindOf: FASTTypeScriptMethodDefinition ]) do: [
		:method | (method accept: self) parentType: famixClass ].

	"In java we are looking also for declarations, superclasses and interfaces; this is currently not supported in FASTTypeScript.
	Perhaps we can look for genericChildren of specific types, but it is not clear yet ... 
	This is why we stopped here."

	^ famixClass
]

{ #category : 'visiting' }
FTSMUModelUpdater >> visitFASTTypeScriptEnumDeclaration: aFastTypeScriptEnumDeclaration [

	| famixEnum |
	famixEnum := self
		                  create: FamixTypeScriptEnum 
		                  from: aFastTypeScriptEnumDeclaration.
	famixEnum name:
		aFastTypeScriptEnumDeclaration name sourceCode.
	famixEnum fast: aFastTypeScriptEnumDeclaration.

	"here we have to search for method signature"
	
	"(aFastTypeScriptInterfaceDeclaration body genericChildren select: [
		 :child | child isKindOf: FASTTypeScriptMethodDefinition ]) do: [
		:method | (method accept: self) parentType: famixEnum ]."

	^ famixEnum
]

{ #category : 'visiting' }
FTSMUModelUpdater >> visitFASTTypeScriptInterfaceDeclaration: aFastTypeScriptInterfaceDeclaration [

	| famixInterface |
	famixInterface := self
		                  create: FamixTypeScriptInterface
		                  from: aFastTypeScriptInterfaceDeclaration.
	famixInterface name:
		aFastTypeScriptInterfaceDeclaration name sourceCode.
	famixInterface fast: aFastTypeScriptInterfaceDeclaration.

	"here we have to search for method signature"
	
	"(aFastTypeScriptInterfaceDeclaration body genericChildren select: [
		 :child | child isKindOf: FASTTypeScriptMethodDefinition ]) do: [
		:method | (method accept: self) parentType: famixInterface ]."

	^ famixInterface
]

{ #category : 'visiting' }
FTSMUModelUpdater >> visitFASTTypeScriptMethodDefinition: aFastTypeScriptMethodDefinition [

	| famixMethod |
	famixMethod := self
		               create: FamixTypeScriptMethod
		               from: aFastTypeScriptMethodDefinition.
	aFastTypeScriptMethodDefinition famix: famixMethod.
	famixMethod name: aFastTypeScriptMethodDefinition name sourceCode.

	"in java we are looking additionaly among for parameters, java annotation, exceptions, type, modifiers"

	^ famixMethod
]
