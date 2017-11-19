sshfs <- function(remote_path, local_path, servername=NULL, id_rsa_path = NULL, useStallo = T) {
    if(is.null(servername)) servername = "YourUserName@YourServer.com:" # put your most used user and servername here to avoid typing in this everytime instantiating this process
    remote_path=paste(servername, remote_path, sep = "")
    suppressWarnings(if(file.exists(local_path)) system(paste("umount -f", local_path))) # if a mount point exist, unmount it first
    system(paste( "mkdir -p", local_path))
    if(is.null(id_rsa_path)) id_rsa_path="~/.ssh/id_rsa" # put the path to your id_rsa file her
    system(paste("sshfs -o Ciphers=arcfour,Compression=no,auto_cache,reconnect,allow_other,defer_permissions,IdentityFile=", id_rsa_path, " ", remote_path, " ", local_path, sep = ""))
}
                     
                     # make sure you have the data.table package
library(data.table)

fread.sshfs <- function(file_with_remote_path, servername=NULL, id_rsa_path = NULL, force = F, ...) {
    if(is.null(servername)) servername = "YourUserName@YourServer.com:" # put your most used user and servername here to avoid typing in this everytime instantiating this process
    remote_path=paste(servername, file_with_remote_path, sep = "")
    HOME=system("printf $HOME", intern = T)

    locally_mounted_file_path = paste(HOME, "/share/", gsub(".*/", "", dirname(file_with_remote_path)), sep = "")
    if(file.exists(locally_mounted_file_path) & force == F) cat("\nMount point already exists. Use another mountpath or set FORCE = TRUE")
    if(file.exists(locally_mounted_file_path) & force == F) break() 
    suppressWarnings(dir.create(locally_mounted_file_path, recursive = T))
    if(is.null(id_rsa_path)) id_rsa_path="~/.ssh/id_rsa" # put path to id_rsa file here to avoid typing in path everytime instantiating this process
    cat(paste("Mounting", dirname(remote_path), "to", locally_mounted_file_path, "..."))
    system(paste("sshfs -o Ciphers=arcfour,Compression=no,auto_cache,reconnect,allow_other,defer_permissions,IdentityFile=", id_rsa_path, " ", dirname(remote_path), " ", locally_mounted_file_path, sep = ""))

    file = paste(locally_mounted_file_path, gsub(dirname(file_with_remote_path), "", file_with_remote_path), sep = "")
    cat("\nReading", file)
    library(data.table)
    temp <- fread(file, ...)

    cat(paste("Umounting and removing", locally_mounted_file_path), "...")
    system(paste("umount -f", locally_mounted_file_path))
    unlink(locally_mounted_file_path, recursive = T, force = T)

    return(temp)
}
