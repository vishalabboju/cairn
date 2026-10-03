import { NextResponse, type NextRequest } from "next/server";
export function middleware(req: NextRequest) {
  const access = req.cookies.get("cairn_access")?.value;
  const url = req.nextUrl;
  const protectedPrefixes = ["/dashboard", "/roadmap", "/assessment", "/onboarding", "/projects", "/opportunities", "/learn", "/pathways", "/profile", "/mentor"];
  if (protectedPrefixes.some((p) => url.pathname.startsWith(p)) && !access) {
    url.pathname = "/login";
    url.searchParams.set("next", req.nextUrl.pathname);
    return NextResponse.redirect(url);
  }
  return NextResponse.next();
}
export const config = { matcher: ["/dashboard/:path*", "/roadmap/:path*", "/assessment/:path*", "/onboarding/:path*", "/projects/:path*", "/opportunities/:path*", "/learn/:path*", "/pathways/:path*", "/profile/:path*", "/mentor/:path*"] };
