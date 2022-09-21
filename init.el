;;; init.el --- halfwhole's personal emacs configuration

;;; Code:

;;;;;;;;;;;;;;;;;;;;
;; MELPA packages ;;
;;;;;;;;;;;;;;;;;;;;

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)


;;;;;;;;;;;;;;;;;
;; Use-package ;;
;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General configurations ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-set-key (kbd "<f10>") 'toggle-frame-maximized)
(global-set-key (kbd "<f11>") 'toggle-frame-fullscreen)

(global-hl-line-mode 1)
(global-display-line-numbers-mode 1)
(show-paren-mode 1)
(desktop-save-mode 1)

(setq display-time-default-load-average nil)  ; Disable showing the system load average
(display-time-mode 1)

(add-to-list 'default-frame-alist '(height . 45))
(add-to-list 'default-frame-alist '(width . 140))
(setq split-height-threshold 80)
(setq split-width-threshold 160)
(setq help-window-select t)

;; Line wrap (continuation lines): only right and no left arrow indicator
(setf (alist-get 'truncation fringe-indicator-alist) '(left-arrow right-arrow))
(setf (alist-get 'continuation fringe-indicator-alist) '(nil right-curly-arrow))

;; Font
;; Alternatives: e.g. DejaVu Sans Mono, Fira Code
(when (member "Fira Code" (font-family-list))
  (set-frame-font "Fira Code 13" t t))

;; Japanese keyboard
(global-set-key [?\M-¥] [?\\])  ; Allow for backslashes using M-¥

;; Ensure $PATH is the same in both emacs and shell (in MacOS)
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; Theme
(use-package doom-themes
  :ensure t
  :init (load-theme 'doom-one t))

;; Undos and saves
(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode)
  (setq undo-tree-history-directory-alist `(("." . "~/.emacs.d/.undo")))
  (setq backup-directory-alist `(("." . "~/.emacs.d/.saves"))))

;; Language settings
(setq js-indent-level 2)  ; 2 spaces instead of 4 spaces
(setq css-indent-offset 2)  ; 2 spaces instead of 4 spaces

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Miscellaneous packages ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (setq flycheck-python-pycompile-executable "python3")
  (setq flycheck-python-pylint-executable "python3")
  (setq flycheck-python-flake8-executable "python3"))
(use-package ivy
  :ensure t
  :config
  (ivy-mode t)
  (define-key ivy-minibuffer-map (kbd "C-u") 'ivy-scroll-down-command)
  (define-key ivy-minibuffer-map (kbd "C-d") 'ivy-scroll-up-command))
(use-package projectile
  :ensure t
  :config (projectile-mode t))
(use-package counsel  ; better completion
  :ensure t
  :config
  (global-set-key (kbd "M-x") 'counsel-M-x))  ; better M-x
(use-package counsel-projectile :ensure t)  ; incremental completion for project search
;; (use-package smex
;;   :ensure t
;;   :config
;;   (global-set-key (kbd "M-x") 'smex)
;;   (global-set-key (kbd "M-X") 'smex-major-mode-commands)
;;   (global-set-key (kbd "C-c M-x") 'execute-extended-command))
(use-package which-key
  :ensure t
  :config (which-key-mode t))
(use-package winner
  :ensure t
  :config (winner-mode t))

(use-package restart-emacs :ensure t)
(use-package magit :ensure t)
(use-package all-the-icons :ensure t)
(use-package doom-modeline
  :ensure t
  :init
  (unless (member "all-the-icons" (font-family-list))
      (all-the-icons-install-fonts))
  (doom-modeline-mode t))
(use-package markdown-mode :ensure t)
(use-package yaml-mode :ensure t)
(use-package package-lint :ensure t)
(use-package flycheck-package
  :ensure t
  :config (flycheck-package-setup))
(use-package esup
  :ensure t
  :config (setq esup-depth 0))
(use-package diff-hl  ; highlight git changes on left side of window
  :ensure t
  :config (global-diff-hl-mode))
(use-package ag :ensure t)  ; enable search, used by projectile
(use-package dumb-jump  ; enable jump to definition
  :ensure t
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  (global-set-key (kbd "<f12>") 'evil-goto-definition))
(use-package highlight-indent-guides  ; highlight indentation levels in code
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
  (setq highlight-indent-guides-method 'character)
  (setq highlight-indent-guides-character ?|)
  (setq highlight-indent-guides-responsive 'top))

;; (use-package company :ensure t)


;;;;;;;;;;;;;;
;; Org mode ;;
;;;;;;;;;;;;;;

(use-package org-tempo)  ; Allow templates such as <s

(setq org-pretty-entities t)
(setq org-format-latex-options
      '(:foreground "White" :background "#222222" :scale 1.5 :html-foreground "default" :html-background "Transparent" :html-scale 1.0 :matchers
		    ("begin" "$1" "$" "$$" "\\(" "\\[")))

(setq org-adapt-indentation nil)
;; (add-hook 'org-mode-hook 'org-indent-mode)

(org-babel-do-load-languages
 'org-babel-load-languages
 (append org-babel-load-languages
	 '((python . t)
	   (java   . t)
	   )))


;;;;;;;;;;;;;;;
;; Evil mode ;;
;;;;;;;;;;;;;;;

(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode t)
  (evil-set-undo-system 'undo-tree)
  (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
  (define-key evil-normal-state-map (kbd "C-d") 'evil-scroll-down)
  (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
  (define-key evil-visual-state-map (kbd "C-d") 'evil-scroll-down)
  (define-key evil-visual-state-map (kbd "g c") 'comment-or-uncomment-region)
  (define-key evil-visual-state-map (kbd "<tab>") 'indent-region)

  ;; (add-hook 'org-mode-hook (lambda () (electric-indent-local-mode -1))) ;; disable auto-indentation of new lines in org
  (add-hook 'org-mode-hook (lambda ()
			     (push '(?$ . ("$" . "$")) evil-surround-pairs-alist)))  ; not working?
  (add-hook 'org-mode-hook (lambda ()
			     (push '(?/ . ("/" . "/")) evil-surround-pairs-alist)))  ; not working?
  (add-hook 'org-mode-hook (lambda ()
			     (setq evil-auto-indent nil)))

  ;; Make these modes not in emacs state, but evil state
  (setq evil-emacs-state-modes (delq 'ibuffer-mode evil-emacs-state-modes))
  (setq evil-emacs-state-modes (delq 'package-menu-mode evil-emacs-state-modes))
  (setq evil-emacs-state-modes (delq 'Custom-mode evil-emacs-state-modes))

  ;; Leader keybindings
  ;; For inspiration, see https://github.com/hlissner/doom-emacs/blob/develop/modules/config/default/+evil-bindings.el
  (use-package evil-leader
    :ensure t
    :config
    (global-evil-leader-mode t)
    (evil-leader/set-leader "<SPC>")

    (define-prefix-command 'buffer-map)  ; b
    (define-key buffer-map "i" 'ibuffer)
    (define-key buffer-map "k" 'kill-buffer)

    (define-prefix-command 'file-map)  ; f
    (define-key file-map "d" 'dired)
    (define-key file-map "p" '(lambda () (interactive) (find-file "~/.emacs.d/init.el")))
    (define-key file-map "s" 'save-buffer)

    (define-prefix-command 'magit-map)  ; g
    (define-key magit-map "g" 'magit)
    (define-key magit-map "b" 'magit-blame)

    (define-prefix-command 'treemacs-map)  ; t
    (define-key treemacs-map "t" 'treemacs)
    (define-key treemacs-map "pa" 'treemacs-add-project-to-workspace)
    (define-key treemacs-map "pr" 'treemacs-remove-project-from-workspace)
    (define-key treemacs-map "wa" ' treemacs-create-workspace)
    (define-key treemacs-map "wr" ' treemacs-remove-workspace)
    (define-key treemacs-map "ws" ' treemacs-switch-workspace)
    (define-key treemacs-map "we" ' treemacs-edit-workspaces)

    (define-prefix-command 'help-map)  ; h
    (define-key help-map "k" 'describe-key)
    (define-key help-map "m" 'describe-mode)
    (define-key help-map "n" 'describe-minor-mode)
    (define-key help-map "f" 'describe-function)
    (define-key help-map "v" 'describe-variable)

    (define-prefix-command 'window-map)  ; w
    (define-key window-map "d" 'evil-window-delete)
    (define-key window-map "k" 'evil-window-up)
    (define-key window-map "j" 'evil-window-down)
    (define-key window-map "h" 'evil-window-left)
    (define-key window-map "l" 'evil-window-right)
    (define-key window-map "K" 'evil-window-move-very-top)
    (define-key window-map "J" 'evil-window-move-very-bottom)
    (define-key window-map "H" 'evil-window-move-far-left)
    (define-key window-map "L" 'evil-window-move-far-right)
    (define-key window-map "v" 'split-window-right)
    (define-key window-map "-" 'split-window-below)
    (define-key window-map "u" 'winner-undo)
    (define-key window-map "r" 'winner-redo)

    (define-prefix-command 'projectile-map)  ; p
    (define-key projectile-map "s" 'counsel-projectile-ag)
    (define-key projectile-map "f" 'counsel-projectile-find-file-dwim)
    (define-key projectile-map "d" 'counsel-projectile-find-dir)

    (evil-leader/set-key
      "." 'find-file
      "b" '("buffer" . buffer-map)
      "c" 'flycheck-list-errors
      "f" '("file" . file-map)
      "g" '("magit" . magit-map)
      "h" '("help" . help-map)
      "m p" 'markdown-preview
      "t" '("treemacs" . treemacs-map)
      ;; "p" '("projectile" . projectile-command-map)
      "p" '("projectile" . projectile-map)
      "q r" 'restart-emacs
      "w" '("window" . window-map)))

  ;; Escape using jk
  (use-package evil-escape
    :ensure t
    :config
    (evil-escape-mode t)
    (setq-default evil-escape-key-sequence "jk"))

  ;; Surround
  (use-package evil-surround
    :ensure t
    :config (global-evil-surround-mode))

  ;; Evil-collection for Magit
  (use-package evil-collection
    :ensure t
    :config
    (evil-collection-init)))


;;;;;;;;;;;;;;
;; Treemacs ;;
;;;;;;;;;;;;;;

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-move-forward-on-expand        nil
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-user-mode-line-format         nil
          treemacs-user-header-line-format       nil
          treemacs-width                         35
          treemacs-workspace-switch-cleanup      nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t
  :config
  (define-key evil-treemacs-state-map (kbd "C-u") 'evil-scroll-up))

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :after (treemacs dired)
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)


;;;;;;;;;;;;;;;;;;;;
;; Custom configs ;;
;;;;;;;;;;;;;;;;;;;;

;; (add-to-list 'load-path "~/.emacs.d/pride-mode")
;; (load "pride-mode.el")
;; (pride-mode)


;;;;;;;;;;;;;;;;;;
;; DO NOT TOUCH ;;
;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#1e1e1e" "#D16969" "#579C4C" "#D7BA7D" "#339CDB" "#C586C0" "#85DDFF" "#d4d4d4"])
 '(custom-safe-themes
   '("6c386d159853b0ee6695b45e64f598ed45bd67c47f671f69100817d7db64724d" "99ea831ca79a916f1bd789de366b639d09811501e8c092c85b2cb7d697777f93" "2f1518e906a8b60fac943d02ad415f1d8b3933a5a7f75e307e6e9a26ef5bf570" "9efb2d10bfb38fe7cd4586afb3e644d082cbcdb7435f3d1e8dd9413cbe5e61fc" "76bfa9318742342233d8b0b42e824130b3a50dcc732866ff8e47366aed69de11" "711efe8b1233f2cf52f338fd7f15ce11c836d0b6240a18fffffc2cbd5bfe61b0" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default))
 '(exwm-floating-border-color "#252526")
 '(fci-rule-color "#37474F")
 '(highlight-tail-colors ((("#232a22" "#232a21") . 0) (("#283134" "#243034") . 20)))
 '(jdee-db-active-breakpoint-face-colors (cons "#171F24" "#237AD3"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#171F24" "#579C4C"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#171F24" "#777778"))
 '(objed-cursor-color "#D16969")
 '(package-selected-packages
   '(flycheck use-package treemacs-evil projectile yaml-mode markdown-mode evil-magit doom-themes evil-surround restart-emacs treemacs evil-escape evil-leader magit ivy-hydra ivy which-key evil))
 '(pdf-view-midnight-colors (cons "#d4d4d4" "#1e1e1e"))
 '(rustic-ansi-faces
   ["#1e1e1e" "#D16969" "#579C4C" "#D7BA7D" "#339CDB" "#C586C0" "#85DDFF" "#d4d4d4"])
 '(vc-annotate-background "#1e1e1e")
 '(vc-annotate-color-map
   (list
    (cons 20 "#579C4C")
    (cons 40 "#81a65c")
    (cons 60 "#acb06c")
    (cons 80 "#D7BA7D")
    (cons 100 "#d8ab79")
    (cons 120 "#d99c76")
    (cons 140 "#DB8E73")
    (cons 160 "#d38b8c")
    (cons 180 "#cc88a6")
    (cons 200 "#C586C0")
    (cons 220 "#c97ca3")
    (cons 240 "#cd7286")
    (cons 260 "#D16969")
    (cons 280 "#ba6c6c")
    (cons 300 "#a37070")
    (cons 320 "#8d7374")
    (cons 340 "#37474F")
    (cons 360 "#37474F")))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; init.el ends here
