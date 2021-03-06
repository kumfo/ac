build:
	go build -o ac
	time ./ac
run:
	GOGC=off ./ac
check:
	python check.py
setup:
	./ramdisk.sh 2
	mkdir -p /ramdisk/vonng
	tar -xf data/dict.txt.tgz -C /ramdisk/vonng
	cat data/xa* | tar -x -C /ramdisk/vonng
clean:
	rm -rf  /tmp/ac.txt
	rm -rf  ac
	rm -rf  ac.darwin
	rm -rf  ac.linux
	rm -rf  profile
	rm -rf bin
p:
	scp 10.191.160.30:/ramdisk/go/src/ac/profile . &&  go tool pprof profile
sync:
    ssh 10.191.160.30 "rm -rf /ramdisk/go/src/ac" && scp -r /Users/vonng/Dev/go/src/ac 10.191.160.30:/ramdisk/go/src/ac

remote:
	GOOS=linux GOARCH=amd64 go build -o ac.linux ac.go
	scp ac.linux 10.191.160.30:/ramdisk/ac.linux
	ssh 10.191.160.30 "GOGC=off time /ramdisk/ac.linux -i /ramdisk/video_title.txt -o /ramdisk/ac.txt"

remotetest:
	GOOS=linux GOARCH=amd64 go build -o ac.linux ac.go
	scp ac.linux 10.191.160.30:/ramdisk/ac.test
rt:
	ssh 10.191.160.30 "GOGC=off time /ramdisk/ac -i /ramdisk/video_title.txt -o /ramdisk/ac.txt"

upload:
	GOOS=linux GOARCH=amd64 go build -o ac.linux ac.go
	scp ac.linux tt:/tmp/ac
	ssh tt "rm /tmp/ac.txt && GOGC=off time /tmp/ac"
.PHONY: install clean upload build run check p sync
