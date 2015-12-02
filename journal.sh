#!/usr/bin/env bash


# -----------------------------------------------------------------------------
# INFO
#
# This is a simple journal helper script that creates Jekyll markdown
# posts automatically, based on the date. It's meant for those who
# are interested in keeping a daily log, but who don't want to
# waste time writing the date every day.
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------------


# Change this to match the path to your journal. Absolute path is best.
# IMPORTANT: Don't put a trailing / on the end!
# Or, if you like, you can put this script in that directory and use this:
# JOURNAL_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
JOURNAL_DIR='/home/lorentrogers/journal'

# Set script variables. Nothing to do here!
readonly APPNAME=$(basename "${0%.sh}")
readonly VERSION=0.1.0
date=$(date +%Y-%m-%d)


# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------


# Logs output to the console. Useful for enabling/disabling verbose.
fn_log_info() {
  printf "$1\n"
}

# Opens today's entry in the journal.
# If there's no entry for today, this function makes a new one with the
# default YAML frontmatter.
# Otherwise, it opens the entry for editing.
fn_open() {
  file_name="$JOURNAL_DIR/_posts/$date-$date.md"
  if [ -e "$file_name" ]
  then
    fn_log_info "$date exists. Opening."
  else
    fn_log_info "New entry: $date"
    # Add the default YAML front matter
    printf '%s\nlayout: post\ntitle: %s\n%s\n\n' \
      '---' "$date" '---' >> "$file_name"
  fi
  # TODO: use default editor / set as config var
  vim -c ":set wrap" "$file_name"
  return 0
}

# If there's no entry for today, this function makes a new one.
# Otherwise, it opens the entry for editing.
# TODO: DRY this up by combining w/ open.
fn_open_yesterday() {
  yesterday=$(date -d '1 day ago' +%Y-%m-%d)
  post="$JOURNAL_DIR/_posts/$yesterday-$yesterday.md"
  if [ -e "$post" ]
  then
    fn_log_info "$yesterday exists. Opening."
    vim -c ":set wrap" "$post"
  else
    fn_log_info "No entry found!"
  fi
  return 0
}

# Runs a git command in the journal directory.
fn_journal_git_cmd() {
  eval "git --git-dir=$JOURNAL_DIR/.git --work-tree=$JOURNAL_DIR $1"
}

# Commits the current state of the journal to Git and
# pushes it to the remote server
fn_save() {
  echo "Saving $date"
  fn_journal_git_cmd "add _posts/*"
  # TODO: more flexable support for those who don't use this folder.
  fn_journal_git_cmd "add assets/*"
  fn_journal_git_cmd "commit -m \"Save: $(date)\""
  # TODO: option to not push, if you don't want to...
  # TODO: option to push to multiple remotes
  fn_journal_git_cmd "push"
  return 0
}

# Removes any temp files used from the last build, and removes
# any old output files which would be overwritten.
fn_pdf_clean_for_build() {
  rm "$JOURNAL_DIR/journal.md" "$JOURNAL_DIR/journal.pdf"
  return 0
}

# Adds the frontmatter to the temp build output, e.g. title, etc.
fn_pdf_append_frontmatter() {
  echo "Appending frontmatter..."
  for f in "$JOURNAL_DIR/frontmatter"/*
  do
    filename=$(basename "$f")
    filename="${filename%.*}"
    echo "$filename"
    cat "$f" >> "$JOURNAL_DIR/journal.md"
  done
  return 0
}

# Appends the contents of the entry files into the temp build output.
# This will then be used to build the final PDF.
fn_pdf_append_md_entries() {
  echo "Appending entries..."
  for f in "$JOURNAL_DIR/entries"/*.md
  do
    filename=$(basename "$f") # extract the date
    filename="${filename%.*}"
    date=$(date -d "$filename" +%m/%d/%Y) # format the date
    # add two newlines before the entry
    printf "\n" >> "$JOURNAL_DIR/journal.md"
    # append the date as a header
    echo "## $date" >> "$JOURNAL_DIR/journal.md"
    # add two newlines before the entry
    printf "\n" >> "$JOURNAL_DIR/journal.md"
    # append the entry content
    cat "$f" >> "$JOURNAL_DIR/journal.md"
    # TODO: allow this to be turned off w/ verbose
    printf "."
  done
  printf "\n"
  return 0
}

# Moves the buildfile into the same directory with the images.
# Builds the pdf using pandoc and deletes the buildfiles.
# cd's into the build directory temporarily so pandoc can find
# the images.
fn_pdf_build_output() {
  mv "$JOURNAL_DIR/journal.md" "$JOURNAL_DIR/entries/"
  cd "$JOURNAL_DIR/entries"
  pandoc -H "$JOURNAL_DIR/latex-options.sty" \
    "$JOURNAL_DIR/entries/journal.md" -o "$JOURNAL_DIR/journal.pdf"
  rm journal.md
  cd -
  return 0
}

# Opens the built PDF in a viewer.
# TODO: This should be more generic... I use Okular, but others may not.
fn_pdf_open_journal_output() {
  okular "$JOURNAL_DIR/journal.pdf" &
  return 0
}

# Builds a PDF of the journal using the markdown files.
fn_pdf_build_journal() {
  echo "Building the journal..."
  fn_pdf_clean_for_build
  touch "$JOURNAL_DIR/journal.md" # make the buildfile
  fn_pdf_append_frontmatter
  fn_pdf_append_md_entries
  fn_pdf_build_output
  fn_pdf_open_journal_output
  return 0
}

# Opens a browser and starts the jekyll preview server.
fn_jekyll_s() {
  cd "$JOURNAL_DIR"
  xdg-open http://localhost:4000 &
  jekyll s
}

# -----------------------------------------------------------------------------
# RUNTIME
# -----------------------------------------------------------------------------


# Handle arguments
if [[ $# -eq 0 ]] ; then
  fn_open
else
  if [ "$1" == "save" ] || [ "$1" == "s" ]
  then
    fn_save
  elif [ "$1" == "yesterday" ]
  then
    fn_open_yesterday
  elif [ "$1" == "build" ]
  then
    # TODO: Re-enable pdf builds that support Jekyll's folder structure
    fn_log_info "Building is disabled"
    # fn_pdf_build_journal
  elif [ "$1" == "preview" ] || [ "$1" == "p" ]
  then
    fn_jekyll_s
  else
    echo "Dang! I don't know what $1 is. Please read the documentation..."
  fi
fi










