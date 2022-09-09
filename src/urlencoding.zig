// Copyright (c) 2022 XXIV
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
const std = @import("std");

extern "C" fn url_encoding_encode(data: [*c]const u8) [*c]u8;

extern "C" fn url_encoding_encode_binary(data: [*c]const u8, length: usize) [*c]u8;

extern "C" fn url_encoding_decode(data: [*c]const u8) [*c]u8;

extern "C" fn url_encoding_decode_binary(data: [*c]const u8, length: usize) [*c]u8;

extern "C" fn url_encoding_free(ptr: [*c]u8) void;

pub const Error = error {
    Null
};

/// Percent-encodes every byte except alphanumerics and -, _, ., ~. Assumes UTF-8 encoding.
/// 
/// Example:
/// * *
/// const std = @import("std");
/// const url = @import("urlencoding");
/// 
/// pub fn main() void {
///     const data = url.encode("This string will be URL encoded.");
///     defer free(data);
///     std.debug.print("{s}\n", .{data});
/// }
/// * *
/// 
/// @param data
/// @return slice of bytes
pub fn encode(data: []const u8) Error![]u8 {
    const str = url_encoding_encode(data.ptr);
    if (str == null) {
        return Error.Null;
    }
    return std.mem.span(str);
}

/// Percent-encodes every byte except alphanumerics and -, _, ., ~.
/// 
/// Example:
/// * *
/// const std = @import("std");
/// const url = @import("urlencoding");
/// 
/// pub fn main() void {
///     const data = url.encodeBinary("This string will be URL encoded.");
///     defer free(data);
///     std.debug.print("{s}\n", .{data});
/// }
/// * *
/// 
/// @param data
/// @return slice of bytes
pub fn encodeBinary(data: []const u8) Error![]u8 {
    const str = url_encoding_encode_binary(data.ptr, data.len);
    if (str == null) {
        return Error.Null;
    }
    return std.mem.span(str);
}

/// Decode percent-encoded string assuming UTF-8 encoding.
/// 
/// Example:
/// * *
/// const std = @import("std");
/// const url = @import("urlencoding");
/// 
/// pub fn main() void {
///     const data = url.decode("%F0%9F%91%BE%20Exterminate%21");
///     defer free(data);
///     std.debug.print("{s}\n", .{data});
/// }
/// * *
/// 
/// @param data
/// @return slice of bytes
pub fn decode(data: []const u8) Error![]u8 {
    const str = url_encoding_decode(data.ptr);
    if (str == null) {
        return Error.Null;
    }
    return std.mem.span(str);
}

/// Decode percent-encoded string as binary data, in any encoding.
/// 
/// Example:
/// * *
/// const std = @import("std");
/// const url = @import("urlencoding");
/// 
/// pub fn main() void {
///     const data = url.decodeBinary("%F1%F2%F3%C0%C1%C2");
///     defer free(data);
///     std.debug.print("{s}\n", .{data});
/// }
/// * *
/// 
/// @param data
/// @return slice of bytes
pub fn decodeBinary(data: []const u8) Error![]u8 {
    const str = url_encoding_decode_binary(data.ptr, data.len);
    if (str == null) {
        return Error.Null;
    }
    return std.mem.span(str);
}

/// function to free the memory after using urlencoding functions
///
/// @param ptr string returned from urlencoding functions
pub fn free(data: []u8) void {
    url_encoding_free(data.ptr);
}

test "encoding" {
    const data = try encode("This string will be URL encoded.");
    const data_bin = try encodeBinary("This string will be URL encoded.");
    defer free(data);
    defer free(data_bin);
    try std.testing.expect(std.mem.eql(u8, "This%20string%20will%20be%20URL%20encoded.", data));
    try std.testing.expect(std.mem.eql(u8, "This%20string%20will%20be%20URL%20encoded.", data_bin));
}

test "decoding" {
    const data = try decode("%F0%9F%91%BE%20Exterminate%21");
    const data_bin = try decodeBinary("%F1%F2%F3%C0%C1%C2");
    defer free(data);
    defer free(data_bin);
    try std.testing.expect(std.mem.eql(u8, "👾 Exterminate!", data));
    try std.testing.expect(std.mem.eql(u8, &[_]u8{ 241, 242, 243, 192, 193, 194 }, data_bin));
}