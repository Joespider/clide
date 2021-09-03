Shell=$(which bash)
#!${Shell}
errorCode()
{
        ${LibDir}/errorCode.sh $@
}

name=$1
Type=$2
oldCode=$3
project=${CodeProject}
name=${name%${LangExt}}
if [ ! -f ${name}${LangExt} ]; then
	#Program Name Given
	if [ ! -z "${name}" ];then
		 Content="import pygame, sys\nfrom pygame.s import *\n\n# Initialize program\npygame.init()\n\n# Assign FPS a value\nFPS = 30\nFramePerSec = pygame.time.Clock()\n\n# Setting up color objects\nBLUE  = (0, 0, 255)\nRED   = (255, 0, 0)\nGREEN = (0, 255, 0)\nBLACK = (0, 0, 0)\nWHITE = (255, 255, 255)\n\n# Setup a 300x300 pixel display with caption\nDISPLAYSURF = pygame.display.set_mode((300,300))\nDISPLAYSURF.fill(WHITE)\npygame.display.set_caption(\"Example\")\n\n# Creating Lines and Shapes\npygame.draw.line(DISPLAYSURF, BLUE, (150,130), (130,170))\npygame.draw.line(DISPLAYSURF, BLUE, (150,130), (170,170))\npygame.draw.line(DISPLAYSURF, GREEN, (130,170), (170,170))\npygame.draw.circle(DISPLAYSURF, BLACK, (100,50), 30)\npygame.draw.circle(DISPLAYSURF, BLACK, (200,50), 30)\npygame.draw.rect(DISPLAYSURF, RED, (100, 200, 100, 50), 2)\npygame.draw.rect(DISPLAYSURF, BLACK, (110, 260, 80, 5))\n\n# Beginning Game Loop\nwhile True:\n\tpygame.display.update()\n\tfor event in pygame.event.get():\n\t\tif event.type == QUIT:\n\t\t\tpygame.quit()\n\t\t\tsys.exit()\n\n\tFramePerSec.tick(FPS)\n"
		touch ${name}${LangExt}
		echo -e "${Content}" > ${name}${LangExt}
	else
		errorCode "newCode"
	fi
fi
