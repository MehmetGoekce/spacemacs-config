;; -*- mode: emacs-lisp; lexical-binding: t -*-

;; ---------------------------------------
;; General Configuration changes
;; ---------------------------------------

;; ---------------------------------------
;; Line numbers
;; native line numbers taking up lots of space?
(setq-default display-line-numbers-width nil)
;; ---------------------------------------

;; ---------------------------------------
;; Searching
;; replace / search with helm-swoop in Evil normal state
(evil-global-set-key 'normal "/" 'helm-swoop)
;;
;; ---------------------------------------

;; ---------------------------------------
;; Helm Descbinds
;; Recent release of helm-descbinds package breaks which-key menu
;; Remove helm-discbinds-mode from helm mode hook to avoid activating
;; https://github.com/syl20bnr/spacemacs/issues/16276
(remove-hook 'helm-mode-hook 'helm-descbinds-mode)
;; ---------------------------------------
;; Add this to your dotspacemacs/user-config function in .spacemacs
(setq treesit-extra-load-path '("~/.emacs.d/tree-sitter/"))

;; ---------------------------------------
;; C/C++: lsp-ui doc popups and sideline only in C/C++ buffers
;; (globally disabled in the lsp layer for minimal visual impact)
(add-hook 'c-mode-common-hook
          (lambda ()
            (setq-local lsp-ui-doc-enable t
                        lsp-ui-sideline-enable t)))
