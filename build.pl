use strict;
use common;
use IPC::Run3 'run3';


my $verbose = common::getArg('verbose', \@ARGV, "info");


sub k8s_install {

    common::dbgLog($verbose, "debug", "k8s_install");

    #TODO: 
    # 1. run curl.exe -LO "https://dl.k8s.io/release/v1.27.3/bin/windows/amd64/kubectl.exe"    
    # 2. place kubectl.exe in place where it will be on path

    my @cmds = (
        "curl.exe -LO \"https://dl.k8s.io/release/v1.27.3/bin/windows/amd64/kubectl.exe\""
    );

    foreach (@cmds) {
        my $result = common::sshExecute($verbose, undef, undef, undef, $_);
        if ($result != common::OK) {
            common::dbgLog($verbose, "error", "Failed to execut $_");
            return common::FAIL;
        }
    }

    return common::OK;

}

sub help {
    my ($targets) = @_;
    foreach my $key (sort keys %$targets) {
        printf("$key - " . $$targets{$key}{'description'} . "\n");
    }
}



sub main {

    my $targets = common::getArg('target', \@ARGV, "build");
    my $help = common::getArg('help', \@ARGV);
    
    my %Targets = (

        "k8s-install" => {
            "sub" => \&k8s_install,
            "description" => "Downloads and installs k8s tools"
        }
    );

    if ($help) {
        help(\%Targets);
        exit common::OK;
    }    


    my @targets = split(",", $targets);
    foreach (@targets) {
        my $target = $_;
        my $targetToExecute = $Targets{$target}{"sub"};
        if ($targetToExecute) {
            common::dbgLog($verbose, "info", "Executing target '$target'");
            my $result =  &$targetToExecute($verbose);
            if ($result) {
                common::dbgLog($verbose, "error", "Target $target returned $result");
                return common::FAIL;
            }
        } else {
            common::dbgLog($verbose, "error", "Unknown target: $targetToExecute");
            return common::FAIL;
        }
    }

    return common::OK;    

}

my $exitCode = main();
exit $exitCode;