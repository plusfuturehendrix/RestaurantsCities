//
//  UserDetailsView.swift
//  TravelDiscoveryLBTA
//
//  Created by Danil Bochkarev on 02.12.2022.
//

import SwiftUI
import Kingfisher

struct UserDetails: Decodable {
    let username, firstName, lastName, profileImage : String
    let followers, following : Int
    let posts: [Post]
}

struct Post: Decodable, Hashable {
    let title, imageUrl, views: String
    let hashtags: [String]
}

class UserDetailsViewModel: ObservableObject {
    @Published var userDetails: UserDetails?
    
    init(userID : Int) {
        guard let url = URL(string: "https://travel.letsbuildthatapp.com/travel_discovery/user?id=\(userID)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, resp, error in
            
            DispatchQueue.main.async {
                guard let data = data else { return }
                
                do {
                    self.userDetails = try JSONDecoder().decode(UserDetails.self, from: data)
                } catch let JSONError {
                    print(JSONError)
                }
            }
        }.resume()
    }
}

struct UserDetailsView: View {
    @ObservedObject var vm : UserDetailsViewModel
    @Environment(\.colorScheme) var colorScheme
    
    let user: User
    
    init(user: User) {
        self.user = user
        self.vm = .init(userID: user.id)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Image(user.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .padding(.horizontal)
                    .padding(.top)
                
                Text("\(self.vm.userDetails?.firstName ?? "") \(self.vm.userDetails?.lastName ?? "")")
                    .font(.system(size: 14, weight: .semibold))
                
                HStack {
                    Text("@\(self.vm.userDetails?.username ?? "None") *")
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.system(size: 10, weight: .semibold))
                    Text("2534")
                }
                .font(.system(size: 12, weight: .regular))
                
                Text("YouTuber, Vlogger, Travel Creator")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(.lightGray))
                
                HStack(spacing: 12) {
                    VStack {
                        Text("59,394")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Followers")
                            .font(.system(size: 9, weight: .regular))
                    }
                    
                    Spacer()
                        .frame(width: 1, height: 10)
                        .background(Color(.lightGray))
                    
                    VStack {
                        Text("2,312")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Following")
                            .font(.system(size: 9, weight: .regular))
                    }
                }
                
                
                HStack(spacing: 12) {
                    Button {
                        
                    } label: {
                        HStack {
                            Spacer()
                            Text("Follow")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .background(Color.orange)
                        .cornerRadius(100)
                    }
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Spacer()
                            Text("Contact")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .background(Color(white: 0.9))
                        .cornerRadius(100)
                    }
                }
                .padding(.horizontal)
                .font(.system(size: 12, weight: .semibold))

                
                ForEach(vm.userDetails?.posts ?? [], id: \.self) { post in
                    VStack(alignment: .leading) {
                        KFImage(URL(string: post.imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 370 ,height: 200)
                            .clipped()
                        
                        HStack {
                            Image(user.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 34)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                Text(post.title)
                                    .font(.system(size: 14, weight: .semibold))
                                
                                Text("\(post.views) views")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray)
                            }
                        }.padding(.horizontal)
                        
                        HStack {
                            ForEach(post.hashtags, id: \.self) { hashtags in
                                Text("#\(hashtags)")
                                    .foregroundColor(Color.blue)
                                    .font(.system(size: 14, weight: .semibold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 1)
                                    .padding(6)
                                    .background(Color(white: 0.9))
                                    .cornerRadius(20)
                            }
                        }
                        .padding(.bottom)
                        .padding(.horizontal, 8)
                    }
                    //.frame(width: 365, height: 200)
                    .background(Color("titleBackground")) //
                    .cornerRadius(12)
                    .shadow(color: .init(white: colorScheme == .light ? 0.8 : 0), radius: 5, x: 0, y: 4)
                }
                
                
            }
        }.navigationBarTitle(user.name, displayMode: .inline)
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            UserDetailsView(user: .init(id: 0, name: "Amy Adams", imageName: "amy"))
        }.colorScheme(.dark)
        
        NavigationView {
            UserDetailsView(user: .init(id: 0, name: "Amy Adams", imageName: "amy"))
        }.colorScheme(.light)
    }
}
