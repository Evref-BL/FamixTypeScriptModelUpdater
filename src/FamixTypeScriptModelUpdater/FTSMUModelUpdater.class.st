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

	| mainFastClassDeclaration newlyCreatedEntity |
	mainFastClassDeclaration := (self fastModel allWithType: FASTTypeScriptClassDeclaration) first.
	newlyCreatedEntity := mainFastClassDeclaration accept: self.

	self updateAssociationFor: newlyCreatedEntity.
	self cleaner clean: famixEntity. 
	^ newlyCreatedEntity
]

{ #category : 'as yet unclassified' }
FTSMUModelUpdater >> updateAssociationFor: newlyCreatedEntity [

	FTSMUModelAssociationUpdater new
		famixModel: newlyCreatedEntity mooseModel;
		fastModel: self fastModel;
		famixEntity: famixEntity;
		newStartPosition: self newStartPosition;
  		newEndPosition: self newEndPosition;
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
	"famixClass fastTypeDefinition: aFastTypeScriptClassDeclaration."

	(aFastTypeScriptClassDeclaration body genericChildren select: [ :child |
		 child isKindOf: FASTTypeScriptMethodDefinition ]) do: [ :method |
		(method accept: self) parentType: famixClass ].
	"(aFastTypeScriptClassDeclaration body genericChildren select: [ :child |
		 child isKindOf: FASTTypeScriptPublicFieldDefinition ]) do: [ :attributes |
		attributes ""declarators"" do: [ :decl | decl accept: self ] ]."

	"aFastTypeScriptClassDeclaration superclass ifNotNil: [ :superclass |
		(aFastTypeScriptClassDeclaration mooseModel allWithType:
			 FASTJavaImportDeclaration)
			detect: [ :importDeclaration |
				importDeclaration qualifiedName name = superclass typeName name ]
			ifFound: [ :importDeclaration |
				famixClass mooseModel allPackages
					detect: [ :pa |
						pa qualifiedName
						= importDeclaration qualifiedName namespace fullName ]
					ifFound: [ :package |
						package types
							detect: [ :type | type name = superclass typeName name ]
							ifOne: [ :type |
								(self create: FamixJavaInheritance)
									subclass: famixClass;
									superclass: type ] ] ]
			ifNone: [
				famixClass mooseModel allModelClasses asOrderedCollection
					detect: [ :class | class name = superclass typeName name ]
					ifOne: [ :class |
						(self create: FamixJavaInheritance)
							subclass: famixClass;
							superclass: class ] ] ].
	aFastTypeScriptClassDeclaration interfaces do: [ :interface |
		(self retrieveClassFromModel: interface typeName name) ifNotNil: [
			:famixInterface |
			(self create: FamixJavaImplementation)
				implementingClass: famixClass;
				interface: famixInterface ] ]."
	^ famixClass
]

{ #category : 'visiting' }
FTSMUModelUpdater >> visitFASTTypeScriptMethodDefinition: aFastTypeScriptMethodDefinition [
	
	| famixMethod | 
	famixMethod := self create: FamixTypeScriptMethod from: aFastTypeScriptMethodDefinition.
	aFastTypeScriptMethodDefinition famix: famixMethod.
	famixMethod name: aFastTypeScriptMethodDefinition name sourceCode.
	
	^ famixMethod
]
