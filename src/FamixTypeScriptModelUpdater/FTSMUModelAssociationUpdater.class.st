Class {
	#name : 'FTSMUModelAssociationUpdater',
	#superclass : 'FASTTypeScriptVisitor',
	#traits : 'TFTSMUEntityFactory',
	#classTraits : 'TFTSMUEntityFactory classTrait',
	#instVars : [
		'newFamixEntity',
		'famixEntity'
	],
	#category : 'FamixTypeScriptModelUpdater-Updater',
	#package : 'FamixTypeScriptModelUpdater',
	#tag : 'Updater'
}

{ #category : 'accessing' }
FTSMUModelAssociationUpdater >> famixEntity [

	^ famixEntity
]

{ #category : 'accessing' }
FTSMUModelAssociationUpdater >> famixEntity: anObject [

	famixEntity := anObject
]

{ #category : 'accessing' }
FTSMUModelAssociationUpdater >> newFamixEntity [

	^ newFamixEntity
]

{ #category : 'accessing' }
FTSMUModelAssociationUpdater >> newFamixEntity: anObject [

	newFamixEntity := anObject
]

{ #category : 'as yet unclassified' }
FTSMUModelAssociationUpdater >> resolveFamixScopeContainerOf: aFASTEntity [

	| scope |
	scope := (aFASTEntity atAnyScope: { 
			          FASTTypeScriptClassDeclaration .
			          FASTTypeScriptMethodDefinition }) anyOne. "pay attention"
	(scope isKindOf: FASTTypeScriptMethodDefinition) ifTrue: [ ^ scope famixMethod ]
]

{ #category : 'updating' }
FTSMUModelAssociationUpdater >> update [

	| mainFastClassDeclaration |
"	mainFastClassDeclaration := (self fastModel allWithType:
		                             FASTTypeScriptClassDeclaration ) detect: [ 
		                            :classDecl | classDecl parentNode isNil ]."
	
		mainFastClassDeclaration := (self fastModel allWithType: FASTTypeScriptClassDeclaration) first .
	
	self newFamixEntity
		bindFastModel: self fastModel
		usingBinder: CRFTSBinderVisitor new.
	mainFastClassDeclaration accept: self
]

{ #category : 'generated' }
FTSMUModelAssociationUpdater >> visitFASTTVariableExpression: aFASTVariableExpression [

	(aFASTVariableExpression parentNode isKindOf:
		 FASTTypeScriptVariableDeclarator) ifTrue: [ ^ self ].

	aFASTVariableExpression famixVariable ifNotNil: [ :famixVariable | 
		| famixAccess |
		famixAccess := self
			               create: FamixTypeScriptAccess
			               from: aFASTVariableExpression.
		famixAccess variable: famixVariable.
		"famixAccess accessor: (self resolveFamixScopeContainerOf: aFASTVariableExpression)" ]
]

{ #category : 'visiting' }
FTSMUModelAssociationUpdater >> visitFASTTypeScriptClassDeclaration: aFASTTypeScriptClassDeclaration [

	"resolve declaredType" 
	famixEntity ifNotNil: [ :originalFamixEntity | 
		originalFamixEntity typedEntities copy do: [ :typedEntity | 
			typedEntity declaredType:
				aFASTTypeScriptClassDeclaration famix ] ].
	"super visitFASTTypeScriptClassDeclaration: aFASTTypeScriptClassDeclaration"
]

{ #category : 'visiting' }
FTSMUModelAssociationUpdater >> visitFASTTypeScriptFieldAccess: aFASTTypeScriptFieldAccess [

	aFASTTypeScriptFieldAccess famixVariable ifNotNil: [ :famixVariable | 
		| famixAccess |
		famixAccess := self
			               create: FamixTypeScriptAccess
			               from: aFASTTypeScriptFieldAccess.
		famixAccess variable: famixVariable.
		famixAccess accessor:
			(self resolveFamixScopeContainerOf: aFASTTypeScriptFieldAccess) ]
]

{ #category : 'visiting' }
FTSMUModelAssociationUpdater >> visitFASTTypeScriptMethodInvocation: aFASTTypeScriptMethodInvocation [

self flag: #'Not supported yet'
	"| famixTypeScriptInvocation parentBehavior |
	famixTypeScriptInvocation := self
		                       create: FamixTypeScriptInvocation
		                       from: aFASTTypeScriptMethodInvocation.
	famixTypeScriptInvocation signature:
		(aFASTTypeScriptMethodInvocation rootNode sourceText
			 copyFrom: aFASTTypeScriptMethodInvocation startPos
			 to: aFASTTypeScriptMethodInvocation endPos).
	parentBehavior := self resolveFamixScopeContainerOf:
		                  aFASTTypeScriptMethodInvocation.
	famixTypeScriptInvocation sender: parentBehavior.
	(aFASTTypeScriptMethodInvocation receiver isNotNil and: [
		 aFASTTypeScriptMethodInvocation receiver famixVariable isNotNil ])
		ifTrue: [
			famixTypeScriptInvocation receiver:
				aFASTTypeScriptMethodInvocation receiver famixVariable ]
		ifFalse: [
			| anImplicitSelf |
			anImplicitSelf := self create: FamixTypeScriptImplicitVariable.
			famixTypeScriptInvocation receiver: anImplicitSelf.
			anImplicitSelf parentBehaviouralEntity: parentBehavior ].
	((famixTypeScriptInvocation receiver isKindOf: FamixTypeScriptImplicitVariable)
		 ifTrue: [
		 (famixTypeScriptInvocation receiver atScope: FamixTClass) anyOne ]
		 ifFalse: [ famixTypeScriptInvocation receiver declaredType ]) ifNotNil: [
		:candidate |
		| realCandidateClass |
		realCandidateClass := (candidate isParametricEntity and: [
			                       candidate isConcreteEntity ])
			                      ifFalse: [ candidate ]
			                      ifTrue: [
			                      candidate genericization genericEntity ].
		realCandidateClass ifNotNil: [ :notNilCandidateClass |
			((candidate isKindOf: FamixTypeScriptInterface)
				 ifTrue: [ notNilCandidateClass methods ]
				 ifFalse: [ notNilCandidateClass allMethods ])
				detect: [ :m | m name = aFASTTypeScriptMethodInvocation name ]
				ifOne: [ :candidateMethod |
					famixTypeScriptInvocation addCandidate: candidateMethod ]
				ifNone: [  ] ] ].
	aFASTTypeScriptMethodInvocation famixInvocation: famixTypeScriptInvocation.
	^ famixTypeScriptInvocation"
]
