.PHONY: combined

combined:
	@copy codebase.bin code.bin
	@armips CampData.s
	@echo Assembled CampData.s

	@armips CampDeployment.s
	@echo Assembled CampDeployment.s

	@armips CampMisc.s
	@echo Assembled CampMisc.s

	@armips CampPositions.s
	@echo Assembled CampPositions.s

	@armips CMVMextended.s
	@echo Assembled CMVMextended.s

	@armips LilithIsMU.s
	@echo Assembled LilithIsMU.s

	@armips NotMyCastle.s
	@echo Assembled NotMyCastle.s

	@armips ScriptedConversations.s
	@echo Assembled ScriptedConversations.s

	@echo Build completed.

cmvmextended:
	@copy codebase.bin code.bin
	@armips CMVMextended.s
	@echo Assembled CMVMextended.s
