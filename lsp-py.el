;;; lsp-py.el --- LSP client implemenation for Python-LSP-Server -*- lexical-binding: t; -*-

;; Copyright (C) 2021-  Anselm Coogan

;; Author: Anselm Coogan <anselm.coogan@icloud.com>
;; Maintainer: Anselm Coogan
;; Version: 0.0.1
;; Package-Requires: ((emacs "25.1") (lsp-mode "6.0"))
;; Homepage: http://github.com/AnselmC/lsp-py
;; Keywords: language-server-protocol, lsp, python, emacs

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; A client for the python-lsp-server (see https://github.com/python-lsp/python-lsp-server) to be used with lsp-mode.

;;; Code:
(require 'lsp-mode)

(defgroup lsp-py nil
  "LSP client for python-lsp-server"
  :group 'lsp-mode
  :link '(url-link "https://github.com/AnselmC/lsp-py"))

(defun lsp-py/install-pip-package (package)
  (shell-command (concat "pip3 install " package)))

(defun lsp-py/install-python-language-server ()
  (lsp-py/install-pip-package "'python-lsp-server[all]'"))

(defun lsp-py/install-flake8-add-on()
  (lsp-py/install-pip-package "pyls-flake8"))

(defun lsp-py/install-mypy-add-on()
  (lsp-py/install-pip-package "pylsp-mypy"))

(defun lsp-py/install-isort-add-on()
  (lsp-py/install-pip-package "pyls-isort"))

(defun lsp-py/install-black-add-on()
  (lsp-py/install-pip-package "python-lsp-black"))

(defun lsp-py/install-memestra-add-on()
  (lsp-py/install-pip-package "pyls-memestra"))

(defun lsp-py/install-rope-add-on()
  (lsp-py/install-pip-package "pylsp-rope"))

;;;###autoload
(defun lsp-py/install-language-server ()
  "Installs language server and optional add-ons"
  (interactive)
  (let ((add-ons-to-install-fn
         '(("flake8" . lsp-py/install-flake8-add-on)
           ("mypy" . lsp-py/install-mypy-add-on)
           ("isort" . lsp-py/install-isort-add-on)
           ("black" . lsp-py/install-black-add-on)
           ("memestra" . lsp-py/install-memestra-add-on)
           ("rope" . lsp-py/install-rope-add-on)))
        (add-ons (completing-read-multiple "Select add-ons: " '(flake8 mypy isort black memestra rope))))
    (lsp-py/install-python-language-server)
    (mapcar (lambda (add-on) (funcall (cdr (assoc add-on add-ons-to-install-fn)))) add-ons)))

(defcustom lsp-py-executable "pylsp"
  "The python-lsp-server executable (installed via `pip install python-lsp-server`)"
  :type 'string
  :group 'lsp-py)

(defcustom lsp-py-configuration-sources ["pycodestyle"]
  "List of configuration sources to use."
  :type 'lsp-string-vector
  :group 'lsp-py)

(defcustom lsp-py-flake8-config nil
  "Path to the config file that will be the authoritative config source."
  :type 'string
  :group 'lsp-py)

(defcustom lsp-py-flake8-enabled nil
  "Enable or disable the plugin."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-flake8-enabled nil
  "Enable or disable the plugin."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-flake8-exclude []
  "List of files or directories to exclude."
  :type 'lsp-string-vector
  :group 'lsp-py)

(defcustom lsp-py-flake8-executable "flake8"
  "Path to the flake8 executable."
  :type 'string
  :group 'lsp-py)

(defcustom lsp-py-flake8-filename nil
  "Only check for filenames matching the patterns in this list."
  :type 'string
  :group 'lsp-py)

(defcustom lsp-py-flake8-hang-closing nil
  "Hang closing bracket instead of matching indentation of opening bracket's line."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-flake8-ignore []
  "List of errors and warnings to ignore (or skip)."
  :type 'lsp-string-vector
  :group 'lsp-py)

(defcustom lsp-py-flake8-max-line-length nil
  "Maximum allowed line length for the entirety of this run."
  :type 'integer
  :group 'lsp-py)

(defcustom lsp-py-flake8-per-file-ignores []
  "A pairing of filenames and violation codes that defines which violations to ignore in a particular file, for example: `[\"file_path.py:W305,W304\"]`)."
  :type 'lsp-string-vector
  :group 'lsp-py)

(defcustom lsp-py-flake8-select []
  "List of errors and warnings to enable."
  :type 'lsp-string-vector
  :group 'lsp-py)

(defcustom lsp-py-jedi-extra-paths []
  "Define extra paths for jedi.Script."
  :type 'lsp-string-vector
  :group 'lsp-py)

(defcustom lsp-py-jedi-env-vars '()
  "Define environment variables for jedi.Script and Jedi.names."
  :type '(alist :key-type 'string :value-type 'string)
  :group 'lsp-py)

(defcustom lsp-py-jedi-environment nil
  "Define environment for jedi.Script and Jedi.names."
  :type 'string
  :group 'lsp-py)

(defcustom lsp-py-jedi-completion-enabled t
  "Enable or disable the plugin."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-jedi-completion-include-params t
  "Auto-completes methods and classes with tabstops for each parameter."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-jedi-completion-include-class-objects t
  "Adds class objects as a separate completion item."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-jedi-completion-fuzzy nil
  "Enable fuzzy when requesting autocomplete."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-jedi-completion-eager nil
  "Resolve documentation and detail eagerly."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-jedi-completion-resolve-at-most 25
  "How many labels and snippets (at most) should be resolved?"
  :type 'integer
  :group 'lsp-py)

(defcustom lsp-py-jedi-completion-cache-for
  ["pandas" "numpy" "tensorflow" "matplotlib"]
  "Modules for which labels and snippets should be cached."
  :type 'lsp-string-vector
  :group 'lsp-py)

(defcustom lsp-py-jedi-definition-enabled t
  "Enable or disable the plugin."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-jedi-definition-follow-imports t
  "The goto call will follow imports."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-jedi-definition-follow-builtin-imports t
  "If follow_imports is T will decide if it follow builtin imports."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-jedi-hover-enabled t
  "Enable or disable the plugin."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-jedi-references-enabled t
  "Enable or disable the plugin."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-jedi-signature-help-enabled t
  "Enable or disable the plugin."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-jedi-symbols-enabled t
  "Enable or disable the plugin."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-jedi-symbols-all-scopes t
  "If T lists the names of all scopes instead of only the module namespace."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-jedi-symbols-include-import-symbols t
  "If T includes symbols imported from other libraries."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-mccabe-enabled t
  "Enable or disable the plugin."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-mccabe-threshold 15
  "The minimum threshold that triggers warnings about cyclomatic complexity."
  :type 'integer
  :group 'lsp-py)

(defcustom lsp-py-preload-enabled t
  "Enable or disable the plugin."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-preload-modules []
  "List of modules to import on startup"
  :type 'lsp-string-vector
  :group 'lsp-py)

(defcustom lsp-py-pycodestyle-enabled t
  "Enable or disable the plugin."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-pycodestyle-exclude []
  "Exclude files or directories which match these patterns."
  :type 'lsp-string-vector
  :group 'lsp-py)

(defcustom lsp-py-pycodestyle-filename []
  "When parsing directories, only check filenames matching these patterns."
  :type 'lsp-string-vector
  :group 'lsp-py)

(defcustom lsp-py-pycodestyle-select []
  "Select errors and warnings"
  :type 'lsp-string-vector
  :group 'lsp-py)

(defcustom lsp-py-pycodestyle-ignore []
  "Ignore errors and warnings"
  :type 'lsp-string-vector
  :group 'lsp-py)

(defcustom lsp-py-pycodestyle-hang-closing nil
  "Hang closing bracket instead of matching indentation of opening bracket's line."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-pycodestyle-max-line-length nil
  "Set maximum allowed line length."
  :type 'integer
  :group 'lsp-py)

(defcustom lsp-py-pydocstyle-enabled nil
  "Enable or disable the plugin."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-pydocstyle-convention nil
  "Choose the basic list of checked errors by specifying an existing convention."
  :type 'string
  :group 'lsp-py)

(defcustom lsp-py-pydocstyle-add-ignore []
  "Ignore errors and warnings in addition to the specified convention."
  :type 'lsp-string-vector
  :group 'lsp-py)

(defcustom lsp-py-pydocstyle-add-select []
  "Select errors and warnings in addition to the specified convention."
  :type 'lsp-string-vector
  :group 'lsp-py)

(defcustom lsp-py-pydocstyle-ignore []
  "Ignore errors and warnings"
  :type 'lsp-string-vector
  :group 'lsp-py)

(defcustom lsp-py-pydocstyle-select []
  "Select errors and warnings"
  :type 'lsp-string-vector
  :group 'lsp-py)

(defcustom lsp-py-pydocstyle-match "(?!test_).*\\.py"
  "Check only files that exactly match the given regular expression; default is to match files that don't start with 'test_' but end with '.py'."
  :type 'string
  :group 'lsp-py)

(defcustom lsp-py-pydocstyle-match-dir "[^\\.].*"
  "Search only dirs that exactly match the given regular expression; default is to match dirs which do not begin with a dot."
  :type 'regexp
  :group 'lsp-py)

(defcustom lsp-py-pyflakes-enabled t
  "Enable or disable the plugin."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-pylint-enabled nil
  "Enable or disable the plugin."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-pylint-args []
  "Arguments to pass to pylint."
  :type 'lsp-string-vector
  :group 'lsp-py)

(defcustom lsp-py-pylint-executable nil
  "Executable to run pylint with. Enabling this will run pylint on unsaved files via stdin. Can slow down workflow. Only works with python3."
  :type 'string
  :group 'lsp-py)

(defcustom lsp-py-rope-completion-enabled t
  "Enable or disable the plugin."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-rope-completion-eager nil
  "Resolve documentation and detail eagerly."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-yapf-enabled t
  "Enable or disable the plugin."
  :type 'boolean
  :group 'lsp-py)

(defcustom lsp-py-rope-extension-modules nil
  "Builtin and c-extension modules that are allowed to be imported and inspected by rope."
  :type 'string
  :group 'lsp-py)

(defcustom lsp-py-rope-rope-folder []
  "The name of the folder in which rope stores project configurations and data.  Pass `nil` for not using such a folder at all."
  :type 'lsp-string-vector
  :group 'lsp-py)

(lsp-register-custom-settings
 '(("pylsp.plugins.flake8.config" lsp-py-flake8-config)
   ("pylsp.plugins.flake8.enabled" lsp-py-flake8-enabled)
   ("pylsp.plugins.flake8.enabled"  lsp-py-flake8-enabled)
   ("pylsp.plugins.flake8.exclude"  lsp-py-flake8-exclude)
   ("pylsp.plugins.flake8.executable"  lsp-py-flake8-executable)
   ("pylsp.plugins.flake8.filename"  lsp-py-flake8-filename)
   ("pylsp.plugins.flake8.hangClosing"  lsp-py-flake8-hang-closing)
   ("pylsp.plugins.flake8.ignore"  lsp-py-flake8-ignore)
   ("pylsp.plugins.flake8.maxLineLength"  lsp-py-flake8-max-line-length)
   ("pylsp.plugins.flake8.perFileIgnores"  lsp-py-flake8-per-file-ignores)
   ("pylsp.plugins.flake8.select"  lsp-py-flake8-select)
   ("pylsp.plugins.jedi.extra_paths"  lsp-py-jedi-extra-paths)
   ("pylsp.plugins.jedi.env_vars"  lsp-py-jedi-env-vars)
   ("pylsp.plugins.jedi.environment"  lsp-py-jedi-environment)
   ("pylsp.plugins.jedi_completion.enabled"  lsp-py-jedi-completion-enabled)
   ("pylsp.plugins.jedi_completion.include_params"  lsp-py-jedi-completion-include-params)
   ("pylsp.plugins.jedi_completion.include_class_objects"  lsp-py-jedi-completion-include-class-objects)
   ("pylsp.plugins.jedi_completion.fuzzy"  lsp-py-jedi-completion-fuzzy)
   ("pylsp.plugins.jedi_completion.eager"  lsp-py-jedi-completion-eager)
   ("pylsp.plugins.jedi_completion.resolve_at_most"  lsp-py-jedi-completion-resolve-at-most)
   ("pylsp.plugins.jedi_completion.cache_for"  lsp-py-jedi-completion-cache-for)
   ("pylsp.plugins.jedi_definition.enabled"  lsp-py-jedi-definition-enabled)
   ("pylsp.plugins.jedi_definition.follow_imports"  lsp-py-jedi-definition-follow-imports)
   ("pylsp.plugins.jedi_definition.follow_builtin_imports"  lsp-py-jedi-definition-follow-builtin-imports)
   ("pylsp.plugins.jedi_hover.enabled"  lsp-py-jedi-hover-enabled)
   ("pylsp.plugins.jedi_references.enabled"  lsp-py-jedi-references-enabled)
   ("pylsp.plugins.jedi_signature_help.enabled"  lsp-py-jedi-signature-help-enabled)
   ("pylsp.plugins.jedi_symbols.enabled"  lsp-py-jedi-symbols-enabled)
   ("pylsp.plugins.jedi_symbols.all_scopes"  lsp-py-jedi-symbols-all-scopes)
   ("pylsp.plugins.jedi_symbols.include_import_symbols"  lsp-py-jedi-symbols-include-import-symbols)
   ("pylsp.plugins.mccabe.enabled"  lsp-py-mccabe-enabled)
   ("pylsp.plugins.mccabe.threshold"  lsp-py-mccabe-threshold)
   ("pylsp.plugins.preload.enabled"  lsp-py-preload-enabled)
   ("pylsp.plugins.preload.modules"  lsp-py-preload-modules)
   ("pylsp.plugins.pycodestyle.enabled"  lsp-py-pycodestyle-enabled)
   ("pylsp.plugins.pycodestyle.exclude" lsp-py-pycodestyle-exclude)
   ("pylsp.plugins.pycodestyle.filename" lsp-py-pycodestyle-filename)
   ("pylsp.plugins.pycodestyle.select" lsp-py-pycodestyle-select)
   ("pylsp.plugins.pycodestyle.ignore" lsp-py-pycodestyle-ignore)
   ("pylsp.plugins.pycodestyle.hangClosing"  lsp-py-pycodestyle-hang-closing)
   ("pylsp.plugins.pycodestyle.maxLineLength"  lsp-py-pycodestyle-max-line-length)
   ("pylsp.plugins.pydocstyle.enabled"  lsp-py-pydocstyle-enabled)
   ("pylsp.plugins.pydocstyle.convention" lsp-py-pydocstyle-convention)
   ("pylsp.plugins.pydocstyle.addIgnore" lsp-py-pydocstyle-add-ignore)
   ("pylsp.plugins.pydocstyle.addSelect" lsp-py-pydocstyle-add-select)
   ("pylsp.plugins.pydocstyle.ignore" lsp-py-pydocstyle-ignore)
   ("pylsp.plugins.pydocstyle.select" lsp-py-pydocstyle-select)
   ("pylsp.plugins.pydocstyle.match"  lsp-py-pydocstyle-match)
   ("pylsp.plugins.pydocstyle.matchDir"  lsp-py-pydocstyle-match-dir)
   ("pylsp.plugins.pyflakes.enabled"  lsp-py-pyflakes-enabled)
   ("pylsp.plugins.pylint.enabled"  lsp-py-pylint-enabled)
   ("pylsp.plugins.pylint.args" lsp-py-pylint-args)
   ("pylsp.plugins.pylint.executable"  lsp-py-pylint-executable)
   ("pylsp.plugins.rope_completion.enabled"  lsp-py-rope-completion-enabled)
   ("pylsp.plugins.rope_completion.eager"  lsp-py-rope-completion-eager)
   ("pylsp.plugins.yapf.enabled"  lsp-py-yapf-enabled)
   ("pylsp.rope.extensionModules"  lsp-py-rope-extension-modules)
   ("pylsp.rope.ropeFolder" lsp-py-rope-rope-folder)
   ))

(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection lsp-py-executable)
                  :activation-fn (lsp-activate-on "python")
                  :server-id 'lsp-py))

(provide 'lsp-py)
;;; lsp-py.el ends here
