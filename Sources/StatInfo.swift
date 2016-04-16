import OperatingSystem

internal struct StatInfo {

	let exists: Bool
	let directory: Bool
	let link: Bool

	init(path: Path) {
		let path = path.path

		var directory = false
		var link = false
		var s = stat()

		if lstat(path, &s) >= 0 {
			if (s.st_mode & S_IFMT) == S_IFLNK {
				link = true

				if stat(path, &s) >= 0 {
					directory = (s.st_mode & S_IFMT) == S_IFDIR
				} else {
					self.init(exists: false, directory: directory, link: link)
					return
				}
			} else {
				directory = (s.st_mode & S_IFMT) == S_IFDIR
			}

			// don't chase the link for this magic case -- we might be /Net/foo
			// which is a symlink to /private/Net/foo which is not yet mounted...
			if (s.st_mode & S_IFMT) == S_IFLNK {
				if (s.st_mode & S_ISVTX) == S_ISVTX {
					self.init(exists: true, directory: directory, link: link)
					return
				}

				// chase the link; too bad if it is a slink to /Net/foo
				stat(path, &s) >= 0
			}
		} else {
			self.init(exists: false, directory: directory, link: link)
			return
		}

		self.init(exists: true, directory: directory, link: link)
	}

	init(exists: Bool, directory: Bool, link: Bool) {
		self.exists = exists
		self.directory = directory
		self.link = link
	}

}
