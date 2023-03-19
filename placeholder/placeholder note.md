what was used to basecall our data?

EpiNano1.2 - better SVM modules & training scripts (supposedly)
MasterOfPores2 - already prepared pipeline (images on DockerHub)
	tombo (from ONT) & EpiNano1.1

Chyba najlepiej byloby uzyc MoP2 jako frameworka i modyfikowac go w razie potrzeby (dodac nowsze, wlasne przetrenowane modele czy inne wersje programow)


modified bases often have low quality.
you could convert docker image into singularity image
megalodon uses remora. I didn't find any drna models
***
to do:
- how to understand results of Epinano? -> make histogram
	how to get over the WT-KO pairs neccessity?

- make MasterOfPores work

- what NAS hardware?
- access to memory from the internet?