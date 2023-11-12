const std = @import("std");
const print = std.debug.print;

// const Status = enum { todo, done };
// const Task = struct { id: u8, text: *const [16]u8, status: Status };

// var tasks = [8]Task;
const Verb = enum { add, delete, list, update };
const verbs = [_][]const u8{ "add", "delete", "list", "update" }; //utilisé pour rationnaliser le code

const Command = struct {
    args: [][]const u8,
    verb: ?Verb = null,
    // pub fn checkVerb(self: Command, user_verb: []const u8) bool {
    //     var verb_exist = false;
    //     for (verbs) |verb| {
    //         if (std.mem.eql(u8, user_verb, verb)) {
    //             print("Vous souhaiter .{s} quelque chose.\n", .{verb});
    //             verb_exist = true;
    //         }
    //     }

    //     return verb_exist;
    // }
    pub fn listArguments(self: Command) void {
        for (self.args, 0..) |arg, i| {
            if (i == 0) continue;
            print("Argument {d}: {s}\n", .{ i, arg });
        }
    }
    pub fn checkArgumentscount(self: Command) CommandError!usize {
        const arguments_count = (self.args.len - 1);
        if (arguments_count > 0) return arguments_count else return CommandError.noArgument;
    }
};

const CommandError: type = error{
    noArgument,
    verbNotExist,
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    const command = Command{ .args = args[0..] };
    // print("type de args[1] : {}\n", .{@TypeOf(args[1])});
    // print("Type de \"add\" : {}\n", .{@TypeOf("add")});
    errdefer {
        print("Une erreur\n", .{});
        giveHelp();
        std.os.exit(1);
    }
    //try checkArguments(args);
    command.listArguments();
    const count = try command.checkArgumentscount();
    print("Vous utiliser {d} argments à votre commande.\n", .{count});
}

// fn checkArguments(args: [][]const u8) !void {
//     const n = checkArgumentscount(args);
//     // prévoir d'autres check et retour d'erreurs possibles
//     if (n) |value| {
//         print("Vous utilisez {d} arguments\n.", .{value});
//         listArguments(args);
//     } else |err| return err;
// }

pub fn giveHelp() void {
    const help =
        \\ Ceci est l'aide d'utilisation
        \\ de ce programme
    ;
    print("{s}. \n", .{help});
}
