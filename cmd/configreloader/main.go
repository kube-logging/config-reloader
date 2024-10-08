package main

import (
	"log"

	"github.com/banzaicloud/config-reloader/pkg/configreloader"
	"github.com/banzaicloud/config-reloader/pkg/metrics"
)

func main() {
	cfg, err := configreloader.New()
	if err != nil {
		log.Fatalln(err)
	}

	err = cfg.Run()
	if err != nil {
		log.Fatalln(err)
	}

	if !*cfg.InitMode {
		err = metrics.Run()
		if err != nil {
			log.Fatalln(err)
		}
	}
}
