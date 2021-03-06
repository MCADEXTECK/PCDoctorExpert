(deffunction selprob ;function definition.
	(?x); arguments passed to the function.
	
	

	(if (eq ?x processor) then
		(assert(procprob yes))
	)
	(if (eq ?x memory) then
		(assert(memprob yes))
	)
	(if (eq ?x harddrive) then
		(assert(hdprob yes))
	)
	(if (eq ?x motherboard) then
		(assert(mbprob yes))
	)
	(if (and(neq ?x processor)(neq ?x memory)(neq ?x harddrive)(neq ?x motherboard)) then
		(assert(endprog yes))
	)
);End deffunction.

;deftemplate for processor diagnosis (nb. I haven't used this)
(deftemplate procproblems

	(slot failure (type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot overheating (type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot system_crash (type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot procspeed_incorrect (type SYMBOL)
		(allowed-symbols yes no)
		(default no))
	
	(slot slowdown (type SYMBOL)
		(allowed-symbols yes no)
		(default no))
)

;deftemplate for processor failure troubleshooting
(deftemplate procfailproblems

	(slot recently_assembled (type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot extra_proc (type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot overheating (type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot inserted_improperly (type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot bios_incorrect (type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot volt_incorrect (type SYMBOL)
		(allowed-symbols yes no)
		(default no))
	
	(slot mboard_notsupport (type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot sec_cache (type SYMBOL)
		(allowed-symbols yes no)
		(default no))
)


;deftemplate for cache troubleshooting
(deftemplate cacheproblems

	(slot cache_disabled (type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot add_cache (type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot insert_improperly (type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot overheating (type SYMBOL)
		(allowed-symbols yes no)
		(default no))	
)

;deftemplate for system overheating troubleshooting
(deftemplate sysheatingproblems

	(slot psfan_notrunning (type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot proc_ovheating (type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot cchips_hot (type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot voltreg_hot (type SYMBOL)
		(allowed-symbols yes no)
		(default no))
	
	(slot bchip_hot (type SYMBOL)
		(allowed-symbols yes no)
		(default no))	

	(slot mem_hot (type SYMBOL)
		(allowed-symbols yes no)
		(default no))	
)

;deftemplate for system slowdown troubleshooting
(deftemplate sysslowdownproblems

	(slot add_mem (type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot hd_light_blink (type SYMBOL)
		(allowed-symbols yes no)
		(default no))
	
)

;deftemplate for system instability troubleshooting
(deftemplate sysinstabilityproblems

	(slot err_messages (type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot app_fail (type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot peripheral_problem (type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot new_pc(type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot vesa_running(type SYMBOL)
		(allowed-symbols yes no)
		(default no))
	
	(slot warmup_problems(type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot leanonbox(type SYMBOL)
		(allowed-symbols yes no)
		(default no))

	(slot bios_changed(type SYMBOL)
		(allowed-symbols yes no)
		(default no))
	
)

;defrule to initialize the k-base
(defrule init
	(initial-fact)
=>
	(assert (startup yes))
)

;defrule to startup the k-base
(defrule startup
	(startup yes)
=>
	(printout t "Enter your problem (processor,memory,harddrive, motherboard): " crlf)
	(bind ?problem (read))
	(selprob ?problem)
)

;defrule to diagnose the processor problems
(defrule processorproblems
	(procprob yes)
=>
	(printout t "Does the Processor appear to be dead, impossible to boot up, or not functioning properly (yes/no)?" crlf)
	(bind ?fail (read))
	
	(if (eq ?fail yes) then
		(assert (proc_fail yes))
		(printout t "Have you recently assembled this P.C. or performed an upgrade to it?" crlf)
		(bind ?upgrade (read))
		(printout t "Do you have another processor available for a quick test?" crlf)
		(bind ?extra (read))
		(printout t "Does it seem like the processor is overheating?" crlf)
		(bind ?oheat (read))
		(printout t "Is the processor inserted improperly?" crlf)
		(bind ?insert (read))
		(printout t "Is the BIOS settings correct?" crlf)
		(bind ?bios (read))
		(printout t "Is the processor receiving the correct voltage?" crlf)
		(bind ?volt (read))
		(printout t "Is the processor supported by this motherboard?" crlf)
		(bind ?mboard (read))
		(printout t "Try disabling the secondary cache in the BIOS setup. Does this work ?" crlf)
		(bind ?cache (read))
		(assert (procfailproblems (recently_assembled ?upgrade)(extra_proc ?extra)(overheating ?oheat)(inserted_improperly ?insert)(bios_incorrect ?bios)(volt_incorrect ?volt)(mboard_notsupport ?mboard)(sec_cache ?cache)))
	)
	
	(if (neq ?oheat yes) then ;not sure
		(printout t "Does it seem like the processor is overheating?" crlf)
		(bind ?oheat (read))
		(if (eq ?oheat yes) then
			(assert (proc_oheat yes))
		)	
		
	)
	
	
	(printout t "Is the system rebooting without warning, or seizing up?" crlf)
	(bind ?crash (read))
	(if (eq ?crash yes) then
		(assert (proc_crash yes))
		
	)	
	(printout t "At boot time, is the system reporting an incorrect processor speed?" crlf)
	(bind ?speed (read))
	(if (eq ?speed yes) then
		(assert (proc_speed yes))

	)	
	(printout t "Is the processor running slowly?" crlf)
	(bind ?slowdown (read))
	(if (eq ?slowdown yes) then
		(assert (proc_slow yes))
		(printout t "Have you recently added more memory to the system?" crlf)
		(bind ?mem (read))
		
		(if (neq ?oheat yes) then ;not sure
			(printout t "Does it seem like the processor is overheating?" crlf)
			(bind ?oheat (read))
			(if (eq ?oheat yes) then
				(assert (proc_oheat yes))
			)
		)	
		
		(printout t "Do you notice the hard disk light flickering when you load a lot of programs or does it say memory is low?" crlf)
		(bind ?flick (read))
		
		(assert (sysslowdownproblems (add_mem ?mem)(hd_light_blink ?flick)))

	)
	
)

;defrule to make recommendations if processor fail is the problem
(defrule procfailrecommend

	(procfailproblems (recently_assembled ?up)(extra_proc ?ex)(overheating ?oh)(inserted_improperly ?ins)(bios_incorrect ?b)(volt_incorrect ?v)(mboard_notsupport ?mb)(sec_cache ?c))

=>
	(if (eq ?up yes) then
		(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
		(printout t "There are a number problems related to new or newly assembled pc's:" crlf)
		(printout t " - Inspect the machine to ensure everything is in order. Many common pitfalls can occur after doing work on a new system." crlf)
		(printout t " - Check for Loose Connections or shorts." crlf)
		(printout t " - Make sure that the motherboard (with CPU, Memory, Video card, and hard drive) is connected to the Power Supply." crlf)
		
		;check if oh = yes assert genoverheating
		;assert power problems
		;assert memory problems
		;assert m-board problems

		(printout t " - Go through the BIOS settings and ensure that they are correct." crlf)
		(printout t " - Check the expansion cards especially for incorrect jumpers and settings." crlf)
		(printout t " - Check the Hard drives and ensure they are jumpered correctly." crlf)
		(printout t " - Check the system for resource conflicts." crlf)	
	) 
	(if (eq ?ex yes) then
		(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
		(printout t "If you have an extra processor:" crlf)
		(printout t " - Try running a quick test by swapping the processor with the other one and see if the problem clears up." crlf)
		(printout t "If it does, then put back the origianl processor and see if the problem returns." crlf)
		(printout t "If it does, you can be certain that the processor is bad, and will need to be replaced." crlf)	
	)
	(if (eq ?oh yes) then
		(assert (proc_oheat yes))		
	)

	(if (eq ?ins yes) then
		(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
		(printout t "If the processor is inserted improperly:" crlf)
		(printout t " - Try fitting it tightly into it's socket, so that it is not rotated." crlf)
	)

	(if (eq ?b yes) then
		(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
		(printout t "If you checked the BIOS settings and they are incorrect:" crlf)
		(printout t " - The jumpers may be set incorrectly." crlf)
		(printout t "This may cause the processor to malfunction, as you may be accidentally overclocking it, or telling the motherboard that it is a different processor than it actually is." crlf)
	)
	
	(if (eq ?v yes) then
		(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
		(printout t "If the voltage is incorrect:" crlf)
		(printout t " - The standard 3.3 to 3.5 volts are required for most processors." crlf)
		(printout t "They require split-rail or dual voltage. Ensure that this supported by your motherboard." crlf)
	)

	(if (eq ?mb yes) then
		(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
		(printout t "If the processor is incompatible with your motherboard:" crlf)
		(printout t " - You may need a BIOS upgrade to use the chip." crlf)
		(printout t "Contact the motherboard manufactuerer's technical support department and try to find out how you can get your motherboard to use it." crlf)
		(printout t " - Also if you are using an Intel motherboard, it may be very likely that you can only use an Intel processor with it. So bear that in mind." crlf)
	)
	
	(if (eq ?c yes) then
		(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
		(printout t "If disabling the secondary cache gets rid of the problem:" crlf)
		(printout t " - You may have a problem with your secondary cache." crlf)
		
		;assert seccacheproblems
	)

	(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
	(printout t "Other important tips for troubleshooting the processor include:" crlf)
	(printout t " - Try toning down the BIOS settings to conservative or default values and see if this solves the problem." crlf)
	(printout t "Incorrect or overly aggressive BIOS settings can cause processors to behave strangely." crlf)
	(printout t " - Try to reduce the speed of the processor to see if it fixes the problem." crlf)
	(printout t "If the problem goes away, then it's quite likely your problem was due to overheating." crlf)
	(printout t " - If the processor can only run at slower speeds, it's possible that you may have unfortunately purchased a remarked CPU." crlf)		
)

(defrule sysslowrecommend
	(sysslowdownproblems (add_mem ?m)(hd_light_blink ?f))
=>
	(if (eq ?m yes) then
		(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
		(printout t "If you recently added more memory and you notice a slowdown:" crlf)
		(printout t " - It may be because your PC does not support caching of over a certain amount." crlf)
		(printout t "Check the type of memory you installed and find out how much cache is required to support it." crlf)
	) 
	(if (eq ?f yes) then
		(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
		(printout t "If the hard disk light is flickering when you load programs or the machine is telling you it does not have enough memory:" crlf)
		(printout t " - It is possible that your machine is thrashing." crlf)
		(printout t " Try closing some of the programs, that should help." crlf)
	)
	(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
	(printout t " - Scan the system for viruses. This may be a contributary factor." crlf)
	(printout t " - Double check BIOS settings to ensure they are in proper order." crlf)
	(printout t " - On an older machine with a functioning turbo switch, make sure it is pressed and the light is on." crlf)
	(printout t " - Try defragmenting the hard disk." crlf)
	(printout t " - Check the amount of free space on the hard disk, as this may be low." crlf)
	(printout t " - Update your Windows drivers." crlf)
	(printout t " - Consider removing unnecessary programs from the system." crlf)
	
)

;defrule to make recommendations if processor overheating is the problem
(defrule procheatrecommend
	(proc_oheat yes)
=>
	(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
		(printout t "To check if the processor is overheating:" crlf)
		(printout t " - Leave the P.C. to run for a while, then turn it off, unplug it, and open it up." crlf)
		(printout t "Ground yourself and touch the processor or it's heat sink (where it attaches tothe processor) carefully." crlf)
		(printout t "If it is very hot, hot enough that you cannot leave your finger on it for more than a few seconds, the processor is probably running hotter than it should be." crlf)
		(printout t " - Consult your motherboard manual and double check all the jumper settings for the processor." crlf)
		(printout t " Make sure that it is set to the correct type and speed." crlf)
		(printout t " - Make sure the processor is inserted properly and is supported by the motherboard." crlf)
		(printout t " - Make sure that the voltage requirements are set properly for the chip and that it is not receiving too much voltage." crlf)
		(printout t " - Make sure that the cooling device (heat sink and cooling fan) being used is appropriate for your processor." crlf)
		(printout t " - Check the CPU fan and ensure that it is still running without obstruction." crlf)
		(printout t " Make sure it is not dirty, worn or looking close to failure, as it may need to be replaced." crlf)
		(printout t " - Ensure that you have heat sink compound between the processor and the heat sink, as this could affect how effectivley the heat sink cools the CPU." crlf)	
		(printout t " - Try installing a stronger cooling fan, a bigger heat sink, or additional fans to help cool down the processor." crlf)

		;assert genoverheating		
		
)

(defrule proc_instability
	(proc_crash yes)
=>
	(assert(sys_crash yes))	
)

(defrule sys_ins_problems
	(sys_crash yes)
=>
	(printout t "Are you getting error messages when the problem occurs?" crlf)
		(bind ?err (read))
		(printout t "Are you experiencing the problem only when running a specific program?" crlf)
		(bind ?app (read))
		(printout t "Does it only occur when using a particular peripheral?" crlf)
		(bind ?per (read))
		(printout t "Do you experience the problem only when the system is warmed up or only when the room is hot?" crlf)
		(bind ?oheat (read))
		(printout t "Is this a new or newly installed P.C.?" crlf)
		(bind ?new (read))
		(printout t "Are you running a VESA local bus video card on a motherboard that supports both VESA and PCI?" crlf)
		(bind ?vesa (read))
		(printout t "Does the problem occur only when you lean on the system box?" crlf)
		(bind ?lean (read))
		(printout t "Have you changed the BIOS settings recently ?" crlf)
		(bind ?changed (read))
		(assert(sysinstabilityproblems (err_messages ?err)(app_fail ?app)(peripheral_problem ?per)(new_pc ?new)(warmup_problems ?oheat)(vesa_running ?vesa)(leanonbox ?lean)(bios_changed ?changed)))	
)

(defrule sys_ins_recommend
	(sysinstabilityproblems (err_messages ?e)(app_fail ?a)(peripheral_problem ?p)(new_pc ?n)(warmup_problems ?o)(vesa_running ?v)(leanonbox ?l)(bios_changed ?c))
=>
	(if (eq ?e yes) then
		(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
		(printout t "If you are getting error messages:" crlf)
		(printout t " - Check your operating system manufactuerer for a listing of error messages and their meanings." crlf)
	) 
	(if (eq ?a yes) then
		(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
		(printout t "If you are having a problem running a specific program:" crlf)
		(printout t " - The application itself may be causing the problem." crlf)
	)
	(if (eq ?p yes) then
		(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
		(printout t "If you notice the problem only occurs when a specific peripheral is used:" crlf)
		(printout t " - There may be a problem with the specific peripheral." crlf)
		(printout t " - There may be a resource conflict that is causing the system to lock up when you try to access two devices using the same resources." crlf)
		(printout t " - There may be a driver problem with the device, that is, if it is something that uses a driver in the operating system." crlf)
	)
	(if (eq ?n yes) then
		;assert newpcproblems
	)
	(if (eq ?o yes) then
		;assert genoverheating
	)
	(if (eq ?v yes) then
		(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
		(printout t "If you are running a VESA card on a board that supports VESA and PCI:" crlf)
		(printout t " - This combination has been known to cause instability." crlf)
		(printout t " - Try replacing the VESA video card with a cheaper PCI card and see if the problem goes away." crlf)
	)
	(if (eq ?l yes) then
		(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
		(printout t "If you notice the problem whenever you lean on the box itself, or when you put the monitor on top of it:" crlf)
		(printout t " - If the problem occurs soon after booting, the weight of the monitor may be pushing down on the case and possibly causing some of the components inside the case to be bent, a cable to be pinched, or the motherboard to be shorted on the case." crlf)	
		(printout t "Also it may be possible that the extra pressure on the case is causing the system to heat up more than it would otherwise." crlf)	
		(printout t " - If your system uses a standard desktop case, do not put the monitor on top of it if the monitor is greater than 17 inch." crlf)
		(printout t " if you are using a slimline case, you may not want to put anything over 15 inch on it." crlf)
		(printout t "  - If the problem is heating, try putting a separator between the case and the monitor. " crlf)
		(printout t " Make sure that the pressure of the monitor is spread out evenly." crlf)
		(printout t " - If the problem is pressure, try opening up the case and rearranging the cables and components, so that when the top cover flexes, nothing is affected." crlf)
		(printout t " - Simply rest the monitor on something other than the case." crlf)
	)
	
	(if (eq ?c yes) then
		(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
		(printout t "If you have recently changed the BIOS settings(especially those that control timing):" crlf)
		(printout t " - If you have noticed the problem since the time of the change, try setting it back to previous values or to low-risk defaults." crlf)
		(printout t "Try setting the system to safe values." crlf)
	)
	(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
	(printout t " - Also, scan for viruses. These are classic virus behavior." crlf)
	(printout t " - Make sure you also disable all power management options in the BIOS." crlf)	
	(printout t " - If you have a network card set up, check your network settings." crlf)
	(printout t " Sometimes the built in Windows networking will use up system resources looking for a network." crlf)
	(printout t "If you are using TCP/IP or some other network protocol, try disabling it and see if it solves your problem. If so, you may need to contact the network card manufactuerer." crlf)
	(printout t " - Scan the hard disk for file system corruption and bad sectors." crlf)
	(printout t " - A badly written driver program can also cause random glitches and lockups. Try running the system with a default driver or one given to you by the manufactuerer." crlf)
	(printout t " - Unreliable power can also cause all sorts of problems. If possible, try running your system off a UPS or swapping the power supply with a new one." crlf)
	(printout t "If this works you have a power problem." crlf)
	;assert power problems

	(printout t " - Try using less aggressive BIOS settings for things like memory timing and hard disk timing." crlf)
	(printout t "Set memory access settings to the lowest possible, disable any performance enhancing BIOS settings." crlf)
	(printout t " - Check for resource conflicts." crlf)
	
	;assert processor problems
	;assert memory problems
	;assert m-board problems
)

(defrule procspeedrecommend
	(proc_speed yes)
=>
	(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
	(printout t " - If you are referring to the LED speed readout on the case, note that this has nothing to do with the processor." crlf)
	(printout t " - If this is a new system, contact the vendor immediately." crlf)
	(printout t " - Double check that the processor is set up properly; check the motherboard jumper settings." crlf)
	(printout t "If it is misconfigured the BIOS may be reflecting an incorrect speed." crlf)
	(printout t " - If the reported speed is off slightly, it may just be a quirk." crlf)
	(printout t " - You may need a BIOS upgrade, if the chip is a newer type than the motherboard." crlf)
)


