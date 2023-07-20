use strict;
use common;
use IPC::Run3 'run3';


my $verbose = common::getArg('verbose', \@ARGV, "info");


sub k8s_install {

    common::dbgLog($verbose, "debug", "k8s_install");

    if (!$ENV{'HOME'}) {
        common::dbgLog($verbose, "error", "HOME env variable is not defined, quiting.");
        return common::FAIL;
    }

    my @cmds = ();

    if (! -e 'kubectl.exe') {
        push @cmds, "curl.exe -LO \"https://dl.k8s.io/release/v1.27.3/bin/windows/amd64/kubectl.exe\"";
    } else {
        common::dbgLog($verbose, "info", "kubetcl.exe already exists, nothing to do.")
    }

    my $k8sHome = $ENV{'HOME'} . '/.kube';
    if (! -d $k8sHome) {
        push @cmds, "mkdir $k8sHome";
    } else {
        common::dbgLog($verbose, "info", "$k8sHome already exists, nothing to do.");
    }

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