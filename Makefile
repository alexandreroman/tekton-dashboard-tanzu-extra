# Copyright 2022 VMware. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

REQUIRED_BINARIES := imgpkg kbld ytt vendir
PACKAGE_VERSIONS := 0.24.1
OCI_IMAGE := ghcr.io/alexandreroman/tekton-dashboard-tanzu-extra

check-carvel:
	$(foreach exec,$(REQUIRED_BINARIES),\
		$(if $(shell which $(exec)),,$(error "'$(exec)' not found. Carvel toolset is required. See instructions at https://carvel.dev/#install")))

sync: check-carvel # Performs a `vendir sync` for each package version.
	$(foreach pkgv,$(PACKAGE_VERSIONS),cd $(pkgv)/bundle && vendir sync)

lock: check-carvel # Updates the image lock file for each package.
	$(foreach pkgv,$(PACKAGE_VERSIONS),cd $(pkgv) && rm -f bundle/.imgpkg/images.yml && kbld --file bundle --imgpkg-lock-output bundle/.imgpkg/images.yml)

push: check-carvel # Build and push packages.
	$(foreach pkgv,$(PACKAGE_VERSIONS),cd $(pkgv) && imgpkg push --bundle $(OCI_IMAGE):${pkgv} --file bundle/)
